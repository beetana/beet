const functions = require("firebase-functions");
const firebaseTools = require("firebase-tools");
const admin = require("firebase-admin");
admin.initializeApp();

exports.deleteUser = functions
  .region("asia-northeast1")
  .firestore
  .document("users/{user}")
  .onDelete(async (snap, context) => {
    try {
      await firebaseTools.firestore
        .delete(snap.ref.path, {
          project: process.env.GCLOUD_PROJECT,
          recursive: true,
          yes: true,
          token: functions.config().fb.token
        });
    } catch (err) {
      console.error(err);
    }
  });

exports.deleteGroup = functions
  .region("asia-northeast1")
  .firestore
  .document("groups/{group}")
  .onDelete(async (snap, context) => {
    try {
      await firebaseTools.firestore
        .delete(snap.ref.path, {
          project: process.env.GCLOUD_PROJECT,
          recursive: true,
          yes: true,
          token: functions.config().fb.token
        });
    } catch (err) {
      console.error(err);
    }
  });
