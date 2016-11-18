/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

import {
  NativeModules,
} from 'react-native';

const { KDSocialShare } = NativeModules;

var Share = {
  shareOnFacebook: function({text, link, imageLink}) {
    return KDSocialShare.shareOnFacebook({text,link,imageLink});
  },

  shareOnMessenger: function({text, link, imageLink}) {
    return KDSocialShare.shareOnMessenger({text,link,imageLink});
  },

  tweet: function({text, link, imageLink}) {
    return KDSocialShare.tweet({text,link,imageLink});
  },

  sendText: function({text, link, imageLink}) {
    return KDSocialShare.sendText({text,link,imageLink});
  },
};

module.exports = Share;