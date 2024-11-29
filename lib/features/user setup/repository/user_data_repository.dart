import 'dart:developer';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/bucket_ids.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/core/typedefs.dart';
import 'package:home_quest/core/utils/image_url_util.dart';
import 'package:home_quest/models/agent.dart';
import 'package:home_quest/models/client.dart';

final userDataRepoProvider = Provider((ref) {
  return UserDataRepository(
    firebaseFirestore: ref.watch(firestoreProvider),
    storage: ref.watch(appwriteStorageProvider),
    firebaseAuth: ref.watch(firebaseAuthProvider),
  );
});

class UserDataRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final Storage storage;
  UserDataRepository({
    required this.firebaseFirestore,
    required this.storage,
    required this.firebaseAuth,
  });

  FutureVoid saveClientData(ClientModel client, File image) async {
    try {
      final imageUrl = await uploadImage(image, ImageBucketIDs.profilePictures);
      ClientModel clientModel = client.copyWith(
          profilePicture: imageUrl, clientID: firebaseAuth.currentUser!.uid);
      await firebaseFirestore
          .collection("clients")
          .doc(clientModel.clientID)
          .set(clientModel.toJson());
    } on (FirebaseException, AppwriteException) catch (e) {
      throw Exception(e.toString());
    }
  }

  FutureVoid saveAgentData(AgentModel agent, File image) async {
    try {
      final imageUrl = await uploadImage(image, ImageBucketIDs.profilePictures);
      AgentModel agentModel = agent.copyWith(
          profilePicture: imageUrl, agentID: firebaseAuth.currentUser!.uid);
      await firebaseFirestore
          .collection("agents")
          .doc(agentModel.agentID)
          .set(agentModel.toJson());
    } on (FirebaseException, Exception) catch (e) {
      throw Exception(e.toString());
    }
  }

  FutureVoid updateField(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      await firebaseFirestore.collection(collection).doc(id).update(data);
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> uploadImage(File file, String bucketId) async {
    try {
      final imageUrl = await storage.createFile(
        bucketId: bucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(
            path: file.path, filename: file.path.split('/').last),
      );
      return genImageUrl(imageUrl.$id, bucketId);
    } on AppwriteException catch (e) {
      log(e.toString());
      throw Exception("Error uploading image");
    }
  }

  Future<bool?> userDataExists() async {
    try {
      final clientDoc = await firebaseFirestore
          .collection("clients")
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      final agentDoc = await firebaseFirestore
          .collection("agents")
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      if (clientDoc.exists) {
        return true;
      }
      return agentDoc.exists;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<ClientModel?> fetchClientData() {
    try {
      return firebaseFirestore
          .collection("clients")
          .doc(firebaseAuth.currentUser!.uid)
          .snapshots()
          .map((snap) => ClientModel.fromJson(snap.data()!));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<AgentModel?> fetchAgentData() {
    try {
      return firebaseFirestore
          .collection("agents")
          .doc(firebaseAuth.currentUser!.uid)
          .snapshots()
          .map((snap) => AgentModel.fromJson(snap.data()!));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
