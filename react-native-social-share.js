/**
 * @providesModule react-native-social-share
 */

'use strict';

import {
  NativeModules,
} from 'react-native';

const { KDSocialShare } = NativeModules;

module.exports = {
  shareOnTwitter: function({text, link, imageLink}, callback) {
    if (!(link || text)) {
      callback("missing_link_or_text");
    } else {
      return KDSocialShare.tweet({text,link,imageLink}, callback);
    }
  },

  shareOnFacebook: function({text, link, imageLink}, callback) {
    if (!(link || text)) {
      callback("missing_link_or_text");
    } else {
      return KDSocialShare.shareOnFacebook({text,link,imageLink}, callback);
    }
  },

  shareOnMessenger: function({text, link, imageLink}, callback) {
    if (!(link || text)) {
      callback("missing_link_or_text");
    } else {
      return KDSocialShare.shareOnMessenger({text,link,imageLink}, callback);
    }
  },

  sendText: function({text, link, imageLink}, callback) {
    return KDSocialShare.sendText({text,link,imageLink}, callback);
  },
};