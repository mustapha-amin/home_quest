import 'dart:io';
import 'dart:developer';

import 'package:appwrite/appwrite.dart' hide Query;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/bucket_ids.dart';
import 'package:home_quest/core/enums.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/core/utils/appwrite_image_upload.dart';
import 'package:home_quest/models/agent.dart';

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

  FutureVoid createListing(PropertyListing propertyListing) async {
    List<String> urls = [];
    try {
      Future.wait(propertyListing.imagesUrls.map((url) async =>
          await uploadImage(storage, File(url), ImageBucketIDs.listings)));

      PropertyListing newProperty = propertyListing.copyWith(imagesUrls: urls);
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

  FutureVoid updateListing(
      PropertyListing propertyListing, List<String> existingImages) async {
    List<String>? urls;
    try {
      if (propertyListing.imagesUrls.isNotEmpty) {
        Future.wait(propertyListing.imagesUrls.map((url) async =>
            await uploadImage(storage, File(url), ImageBucketIDs.listings)));
      }
      final newPropertyListing =
          propertyListing.copyWith(imagesUrls: [...existingImages, ...?urls]);
      await firebaseFirestore
          .collection('listings')
          .doc(propertyListing.id)
          .set(newPropertyListing.copyWith(bathrooms: 1).toJson());
      log("Updated successfully");
      log(newPropertyListing.toJson().toString());
    } on (FirebaseException, AppwriteException) catch (e) {
      throw Exception(e.toString());
    } on SocketException catch (_) {
      throw Exception(
          "A network error occured. Please check your internet connection and try again");
    }
  }

  FutureVoid updateListingStatus(
      PropertyListing listing, AgentModel agent) async {
    try {
      await firebaseFirestore
          .collection('listings')
          .doc(listing.id)
          .update({'available': !listing.available});
      await firebaseFirestore.collection('agents').doc(listing.agentID).update({
        'revenue': listing.available
            ? agent.revenue + listing.agentFee.toInt()
            : agent.revenue - listing.agentFee.toInt()
      });
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
      PropertyFilter filter) async {
    try {
      final docs = await firebaseFirestore.collection('listings').get();
      return docs.docs
          .map((e) => PropertyListing.fromJson(e.data()))
          .where((listing) {
        return listing.price >= filter.minPrice! &&
            listing.price <= filter.maxPrice! &&
            (filter.lga == null || listing.lga == filter.lga) &&
            (filter.state == null || listing.state == filter.state) &&
            (filter.condition == Condition.all ||
                listing.condition == filter.condition) &&
            listing.listingType == filter.listingType &&
            (filter.propertyType == PropertyType.all ||
                listing.propertyType == filter.propertyType) &&
            (filter.propertySubtype == PropertySubtype.all ||
                listing.propertySubtype == filter.propertySubtype) &&
            (filter.bathrooms == 0 || listing.bathrooms == filter.bathrooms) &&
            (filter.bedrooms == 0 || listing.bedrooms == filter.bedrooms) &&
            (filter.kitchens == 0 || listing.kitchens == filter.kitchens) &&
            (filter.sittingRooms == 0 ||
                listing.sittingRooms == filter.sittingRooms) &&
            listing.propertySize >= filter.minPropertySize! &&
            listing.propertySize <= filter.maxPropertySize!;
      }).toList();

      //Query query = firebaseFirestore.collection('listings');

      // if (filter.state != null) {
      //   query = query.where('state', isEqualTo: filter.state);
      //   query = query.where('lga', isEqualTo: filter.lga);
      // }

      // if (filter.listingType != null) {
      //   query = query.where('listingType', isEqualTo: filter.listingType!.name);
      // }

      // if (filter.condition != Condition.all) {
      //   query = query.where('condition', isEqualTo: filter.condition!.name);
      // }

      // if (filter.propertyType != PropertyType.all) {
      //   query =
      //       query.where('propertyType', isEqualTo: filter.propertyType!.name);
      // }

      // if (filter.propertySubtype != PropertySubtype.all) {
      //   query = query.where('propertySubtype',
      //       isEqualTo: filter.propertySubtype!.name);
      // }

      // bool hasPriceFilter = filter.minPrice != null || filter.maxPrice != null;
      // bool hasPropertySizeFilter =
      //     filter.minPropertySize != null || filter.maxPropertySize != null;

      // if (hasPriceFilter) {
      //   if (filter.minPrice != null) {
      //     query = query.where('price', isGreaterThanOrEqualTo: filter.minPrice);
      //   }
      //   if (filter.maxPrice != null) {
      //     query = query.where('price', isLessThanOrEqualTo: filter.maxPrice);
      //   }
      // } else if (hasPropertySizeFilter) {
      //   if (filter.minPropertySize != null) {
      //     query = query.where('propertySize',
      //         isGreaterThanOrEqualTo: filter.minPropertySize);
      //   }
      //   if (filter.maxPropertySize != null) {
      //     query = query.where('propertySize',
      //         isLessThanOrEqualTo: filter.maxPropertySize);
      //   }
      // }

      // if (filter.bedrooms != 0) {
      //   query = query.where('bedrooms', isEqualTo: filter.bedrooms);
      // }

      // if (filter.bathrooms != 0) {
      //   query = query.where('bathrooms', isEqualTo: filter.bathrooms);
      // }

      // if (filter.kitchens != 0) {
      //   query = query.where('kitchens', isEqualTo: filter.kitchens);
      // }

      // if (filter.sittingRooms != 0) {
      //   query = query.where('sittingRooms', isEqualTo: filter.sittingRooms);
      // }

      // final result = await query.get();
      // List<PropertyListing> listings = result.docs
      //     .map((doc) =>
      //         PropertyListing.fromJson(doc.data() as Map<String, dynamic>))
      //     .toList();

      // if (hasPriceFilter && hasPropertySizeFilter) {
      //   listings = listings.where((listing) {
      //     if (filter.minPropertySize != null &&
      //         listing.propertySize < filter.minPropertySize!) {
      //       return false;
      //     }
      //   if (filter.maxPropertySize != null &&
      //       listing.propertySize > filter.maxPropertySize!) {
      //     return false;
      //   }
      //   return true;
      // }).toList();
      //}
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    } on SocketException catch (_) {
      throw Exception(
          "A network error occurred. Please check your internet connection and try again");
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
