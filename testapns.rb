require 'apns'

APNS.host = 'gateway.sandbox.push.apple.com'
APNS.port = 2195
APNS.pem = '/Users/jaychae/Developers/Personal/ews-api/ewsapns.pem'
APNS.pass = "Wndud11590"
devce_token = 'd418d4ec5c96c7234a8fa4b7cee2837933f1ab9aff5824642afbf3a3ff9ef0fb'
APNS.send_notification(devce_token, "hello")


