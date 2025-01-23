import 'dart:io';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/bucket_ids.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/core/utils/appwrite_image_upload.dart';

import '../../../../../core/typedefs.dart';
import '../../../../../models/property_listing.dart';

final propertyListingRepoProvider = Provider((ref) {
  return PropertyListingRepo(
    firebaseFirestore: ref.watch(firestoreProvider),
    storage: ref.watch(appwriteStorageProvider),
    firebaseAuth: ref.watch(firebaseAuthProvider),
  );
});

class PropertyListingRepo {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final Storage storage;

  PropertyListingRepo({
    required this.firebaseFirestore,
    required this.storage,
    required this.firebaseAuth,
  });

  FutureVoid createListing(
      PropertyListing propertyListing, List<String>? existingImages) async {
    List<String> urls = [];
    try {
      if (propertyListing.imagesUrls.isNotEmpty) {
        urls = await Future.wait(propertyListing.imagesUrls.map(
            (url) => uploadImage(storage, File(url), ImageBucketIDs.listings)));
      }
      PropertyListing newProperty =
          propertyListing.copyWith(imagesUrls: [...?existingImages, ...urls]);
      await firebaseFirestore
          .collection('listings')
          .doc(newProperty.id)
          .set(newProperty.toJson());
      log("Listed successfully");
    } on (FirebaseException, AppwriteException) catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  FutureVoid updateListing(PropertyListing propertyListing) async {
    try {
      await firebaseFirestore
          .collection('listings')
          .doc(propertyListing.id)
          .set(propertyListing.toJson(), SetOptions(merge: true));
    } on (FirebaseException, AppwriteException) catch (e) {
      throw Exception(e.toString());
    } on SocketException catch (_) {
      throw Exception(
          "A network error occured. Please check your internet connection and try again");
    }
  }

  FutureVoid deleteListing(String? id) async {
    try {
      await firebaseFirestore.collection('listings').doc(id).delete();
    } on (FirebaseException, AppwriteException) catch (e) {
      throw Exception(e.toString());
    } on SocketException catch (_) {
      throw Exception(
          "A network error occured. Please check your internet connection and try again");
    }
  }

  Future<List<PropertyListing>> fetchListingsByIDs(List<String> ids) async {
    try {
      List<List<String>> chunkedIds = [];
      for (int i = 0; i < ids.length; i += 10) {
        chunkedIds
            .add(ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10));
      }

      List<DocumentSnapshot<Map<String, dynamic>>> documents = [];

      for (List<String> chunk in chunkedIds) {
        final querySnapshot = await firebaseFirestore
            .collection('listings')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        documents.addAll(querySnapshot.docs);
      }

      return documents
          .map((doc) => PropertyListing.fromJson(doc.data()!))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    } on SocketException catch (_) {
      throw Exception(
          "A network error occured. Please check your internet connection and try again");
    }
  }

  Stream<List<PropertyListing>?> fetchListings() {
    try {
      return firebaseFirestore.collection('listings').snapshots().map(
            (snap) => snap.docs
                .map((e) => PropertyListing.fromJson(e.data()))
                .toList(),
          );
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    } on SocketException catch (_) {
      throw Exception(
          "A network error occured. Please check your internet connection and try again");
    }
  }

  Future<List<PropertyListing>> fetchListingsWithFilters(
    PropertyFilter filter,
  ) async {
    try {
      final result = await firebaseFirestore
          .collection('listings')
          .where('price', isGreaterThanOrEqualTo: filter.minPrice)
          .where('price', isLessThanOrEqualTo: filter.maxPrice)
          .where('lga', isEqualTo: filter.lga)
          .where('state', isEqualTo: filter.state)
          .where('listingType', isEqualTo: filter.listingType!.name)
          .where('condition', isEqualTo: filter.condition!.name)
          .where('propertySubtype', isEqualTo: filter.propertySubtype!.name)
          .where('propertyType', isEqualTo: filter.propertyType!.name)
          .where('propertySize', isGreaterThanOrEqualTo: filter.minPropertySize)
          .where('propertySize', isLessThanOrEqualTo: filter.maxPropertySize)
          .where('bathrooms', isEqualTo: filter.bathrooms)
          .where('bedrooms', isEqualTo: filter.bedrooms)
          .where('kitchens', isEqualTo: filter.kitchens)
          .where('sittingRooms', isEqualTo: filter.sittingRooms)
          .get();
      return result.docs
          .map((doc) => PropertyListing.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    } on SocketException catch (_) {
      throw Exception(
          "A network error occured. Please check your internet connection and try again");
    }
  }

  Stream<List<PropertyListing>> fetchListingsByAgentID(String? id) {
    try {
      final results = firebaseFirestore
          .collection('listings')
          .where('agentID', isEqualTo: id);
      return results.snapshots().map((doc) =>
          doc.docs.map((e) => PropertyListing.fromJson(e.data())).toList());
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    } on SocketException catch (_) {
      throw Exception(
          "A network error occured. Please check your internet connection and try again");
    }
  }
}
