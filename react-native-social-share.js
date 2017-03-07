/**
 * @providesModule react-native-social-share
 */

'use strict';

import {
  NativeModules,
} from 'react-native';

const { KDSocialShare } = NativeModules;

const makeCallback = (resolve, reject) => (result, message) => {
  if (result === 'error') {
    reject(message || result);
  } else {
    resolve(result === 'success');
  }
}

module.exports = {
  shareOnTwitter: function({text, link, imageLink}) {
    return new Promise((resolve, reject) => {
      if (!(link || text)) {
        reject("missing_link_or_text");
      } else {
        return KDSocialShare.tweet({text,link,imageLink}, makeCallback(resolve, reject));
      }
    });
  },

  shareOnFacebook: function({text, link, imageLink}) {
    return new Promise((resolve, reject) => {
      if (!(link || text)) {
        reject("missing_link_or_text");
      } else {
        return KDSocialShare.shareOnFacebook({text,link,imageLink}, makeCallback(resolve, reject));
      }
    });
  },

  shareOnMessenger: function({text, link, imageLink}) {
    return new Promise((resolve, reject) => {
      if (!(link || text)) {
        reject("missing_link_or_text");
      } else {
        return KDSocialShare.shareOnMessenger({text,link,imageLink}, makeCallback(resolve, reject));
      }
    });
  },

  sendText: function({text, link, imageLink}) {
    return new Promise((resolve, reject) => {
      if (!(link || text)) {
        reject("missing_link_or_text");
      } else {
        return KDSocialShare.sendText({text,link,imageLink}, makeCallback(resolve, reject));
      }
    });
  },
};