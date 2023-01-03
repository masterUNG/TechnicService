import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:technicservice/models/banner_model.dart';
import 'package:technicservice/models/chat_model.dart';
import 'package:technicservice/models/message_model.dart';
import 'package:technicservice/models/referance_model.dart';
import 'package:technicservice/models/typetechnic_model.dart';
import 'package:technicservice/models/user_model.dart';
import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/utility/app_service.dart';

class AppController extends GetxController {
  RxBool redEye = true.obs;
  RxInt indexTypeUser = 0.obs;
  RxInt indexBody = 0.obs;
  RxBool loadRecerance = true.obs;

  RxList<UserModel> userModelLogins = <UserModel>[].obs;
  RxList<String> uidLogins = <String>[].obs;

  RxList<UserModel> userModels = <UserModel>[].obs;
  RxList<File> files = <File>[].obs;
  RxList<String> typeUsers = <String>[].obs;
  RxList<ReferanceModel> referanceModels = <ReferanceModel>[].obs;
  RxList<BannerModel> bannerModels = <BannerModel>[].obs;
  RxList<UserModel> technicUserModels = <UserModel>[].obs;

  RxList<String> docIdChats = <String>[].obs;
  RxList<String> messageChats = <String>[].obs;
  RxList<MessageModel> messageModels = <MessageModel>[].obs;

  RxList<String> docIdChatUserTechnics = <String>[].obs;
  RxList<ChatModel> chatModelUserTechnic = <ChatModel>[].obs;
  RxList<String> nameUserOrTechnics = <String>[].obs;
  RxList<String> lastMessages = <String>[].obs;

  Future<void> readDocIdChatUserTechnics({required String uid}) async {
    if (docIdChatUserTechnics.isNotEmpty) {
      docIdChatUserTechnics.clear();
      chatModelUserTechnic.clear();
      nameUserOrTechnics.clear();
      lastMessages.clear();
    }

    await FirebaseFirestore.instance
        .collection('chat')
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          ChatModel chatModel = ChatModel.fromMap(element.data());
          if (chatModel.friends.contains(uid)) {
            docIdChatUserTechnics.add(element.id);
            chatModelUserTechnic.add(chatModel);

            var friends = chatModel.friends;
            friends.remove(uid);

            await AppService().findUserModel(uid: friends.last).then((value) {
              nameUserOrTechnics.add(value.name);
            });

            await FirebaseFirestore.instance
                .collection('chat')
                .doc(element.id)
                .collection('message')
                .orderBy('timestamp')
                .get()
                .then((value) {
              if (value.docs.isNotEmpty) {
                MessageModel? messageModel;
                for (var element in value.docs) {
                  messageModel = MessageModel.fromMap(element.data());
                }
                lastMessages.add(messageModel?.message ?? 'Last Message');
              } else {
                lastMessages.add('');
              }
            });
          }
        }
      }
    });
  }

  Future<void> readMessageModels() async {
    if (docIdChats.isNotEmpty) {
      print('##28dec from readMessageModel docId ---> ${docIdChats.last}');
      await FirebaseFirestore.instance
          .collection('chat')
          .doc(docIdChats.last)
          .collection('message')
          .orderBy('timestamp')
          .snapshots()
          .listen((event) {
        if (messageModels.isNotEmpty) {
          messageModels.clear();
        }

        if (event.docs.isNotEmpty) {
          for (var element in event.docs) {
            MessageModel messageModel = MessageModel.fromMap(element.data());
            messageModels.add(messageModel);
          }
        }
      });
    }
  }

  Future<void> findDocIdChats(
      {required String uidLogin, required String uidFriend}) async {
    if (docIdChats.isNotEmpty) {
      docIdChats.clear();
    }

    await FirebaseFirestore.instance
        .collection('chat')
        .get()
        .then((value) async {
      print('##28dec from findDocIdChars value --> ${value.docs}');

      bool createDocument = true;

      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          ChatModel chatModel = ChatModel.fromMap(element.data());
          if ((chatModel.friends.contains(uidLogin)) &&
              (chatModel.friends.contains(uidFriend))) {
            docIdChats.add(element.id);
            createDocument = false;
            readMessageModels();
          }
        }
        if (createDocument) {
          await createNewChat(uidLogin, uidFriend);
        }
      } else {
        createNewChat(uidLogin, uidFriend);
      }
    });
  }

  Future<void> createNewChat(String uidLogin, String uidFriend) async {
    var friends = <String>[];
    friends.add(uidLogin);
    friends.add(uidFriend);
    ChatModel model = ChatModel(friends: friends);

    await FirebaseFirestore.instance
        .collection('chat')
        .doc()
        .set(model.toMap())
        .then((value) {
      findDocIdChats(uidLogin: uidLogin, uidFriend: uidFriend);
    });
  }

  Future<void> readTechnicUserModel() async {
    if (technicUserModels.isNotEmpty) {
      technicUserModels.clear();
    }

    await FirebaseFirestore.instance
        .collection('user')
        .where('typeUser', isEqualTo: AppConstant.typeUsers[1])
        .get()
        .then((value) {
      for (var element in value.docs) {
        UserModel model = UserModel.fromMap(element.data());
        technicUserModels.add(model);
      }
    });
  }

  Future<void> readBanner() async {
    if (bannerModels.isNotEmpty) {
      bannerModels.clear();
    }

    await FirebaseFirestore.instance.collection('banner').get().then((value) {
      for (var element in value.docs) {
        BannerModel model = BannerModel.fromMap(element.data());
        bannerModels.add(model);
      }
    });
  }

  Future<void> readTechnicReferance({String? uidTeachnic}) async {
    var user = FirebaseAuth.instance.currentUser;

    String uid = user!.uid;

    if (uidTeachnic != null) {
      uid = uidTeachnic;
    }

    if (referanceModels.isNotEmpty) {
      referanceModels.clear();
    }

    await FirebaseFirestore.instance
        .collection('referance')
        .where('uidTechnic', isEqualTo: uid)
        .get()
        .then((value) {
      loadRecerance.value = false;

      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          ReferanceModel model = ReferanceModel.fromMap(element.data());
          referanceModels.add(model);
        }
      }
    });
  }

  Future<void> readAllReferance() async {
    if (referanceModels.isNotEmpty) {
      referanceModels.clear();
    }

    await FirebaseFirestore.instance
        .collection('referance')
        .get()
        .then((value) async {
      loadRecerance.value = false;

      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          ReferanceModel model = ReferanceModel.fromMap(element.data());
          referanceModels.add(model);
        }
      }
    });
  }

  Future<void> readAllTypeUser() async {
    if (typeUsers.isNotEmpty) {
      typeUsers.clear();
    }

    await FirebaseFirestore.instance
        .collection('typeteachnic')
        .get()
        .then((value) {
      for (var element in value.docs) {
        TypeTechnicModel typeTechnicModel =
            TypeTechnicModel.fromMap(element.data());
        typeUsers.add(typeTechnicModel.name);
      }
    });
  }

  Future<void> findUserModel({required String uid}) async {
    if (userModels.isNotEmpty) {
      userModels.clear();
    }

    await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .get()
        .then((value) {
      UserModel userModel = UserModel.fromMap(value.data()!);
      userModels.add(userModel);
    });
  }

  Future<void> findUserModelLogins() async {
    if (userModelLogins.isNotEmpty) {
      userModelLogins.clear();
      uidLogins.clear();
    }

    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      uidLogins.add(user.uid);
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get()
          .then((value) {
        UserModel userModel = UserModel.fromMap(value.data()!);
        print('userModel -----> ${userModel.toMap()}');
        userModelLogins.add(userModel);
      });
    }
  }
}
