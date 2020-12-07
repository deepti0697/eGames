//
//  KeyConstant.swift
//

import Foundation
import UIKit

struct KeyConstant {
    
    
    static let user_Default = UserDefaults.standard
    static let deviceUUID = UIDevice.current.identifierForVendor!.uuidString
    static let deviceModelName = UIDevice.current.model
    
    static let ksellerType = "ksellerType"
    static let kDeviceToken = "kDeviceToken"
    static let kSelectedTabBarIndex = "kSelectedTabBarIndex"
    
    static let kUserSessionTempId = "kUserSessionTempId"
    static let kGuestSaveDeviceID = "kGuestSaveDeviceID"
    
    static let pointsViewHide = "pointsViewHide"
    static let pointsViewShow = "pointsViewShow"
    
    static let kCheckoutGuestId = "kCheckoutGuestId"
    static let kFromGuestCheckoutLogin = "kFromGuestCheckoutLogin"
    static let kpush_notification_offerid = "push_notification_offerid"
    static let push_notification_myorder = "push_notification_myorder"
    
    
    
    static let kNoPower = 9999999.0
    
    
    
    static let kuserId = "kuserId"
    static let kuserName = "kuserName"
    static let kuserEmail = "kuserEmail"
    static let kuserPhone = "kuserPhone"
    static let kuserProfilePhoto = "kuserProfilePhoto"
    static let kIsUserLogin = "kIsUserLogin"
    static let kuserCountryCode = "kuserCountryCode"
    
    
    static let kSelectedCountry = "kSelectedCountry"
    static let kSelectedLanguage = "kSelectedLanguage"
    static let kSelectedCurrency = "kSelectedCurrency"
    
    static let kSelectedDeviceCurrency = "AppleLanguages"
    static let kArabicCode = "ar"
    static let kEnglishCode = "en"
    
    
    static let ksliderActive = "ksliderActive"
    
    //static let aramexDeliverTrack = "https://www.aramex.com/track/results?ShipmentNumber="
    static let aramexDeliverTrack = "https://www.postaplus.com/?trackid="
    
    static let kBaseDomain = "http://139.59.93.33/"//"https://lenzzo.com/"
    static let kBaseURL = kBaseDomain + "mobile/api/"
    //static let kBaseURL = kBaseDomain + "mobile/api/"
    
    
    //
    //    static let kBaseDomain = "http://dndtestserver.com/lenzzo/"
    //    static let kBaseURL = kBaseDomain + "mobile/api/"
    
    
    static let sharedAppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let kImageBaseBannerSliderURL = kBaseDomain + "uploads/banners/"
    static let kImageBaseBrandURL = kBaseDomain + "uploads/brand/"
    static let kImageBaseCategoryURL = kBaseDomain + "uploads/category/"
    static let kImageBaseProductURL = kBaseDomain + "uploads/product/"
    static let kImageBaseGiftsURL = kBaseDomain + "uploads/gifts/"
    static let kImageBasePayURL = kBaseDomain + "uploads/logo/"
    static let kImageBannerFamilyURL = kBaseDomain + "uploads/product/"
    
    static let kImageBaseFlagURL = kBaseDomain + "uploads/country_flag/"
    static let kImageSocialURL = kBaseDomain + "uploads/social/"
    static let kImageProfilePicURL = kBaseDomain + "uploads/users/"
    
    static let APIHomeInfo = "home"
    static let APIBrandList = "brandlist"
    static let APICategoriesList = "categorylist"
    static let APICategoriesProductList = "productlist_of_category"
    static let APIBrandProductList = "productlist_of_brand"
    static let APIProductSearchByName = "product_search_by_name"
    static let APIFamilyProductList = "productlist_of_family"
    
    static let APIProductDetails = "product_detail"
    static let APIViewBrandOfCat = "brandlist_of_category"
    
    static let APIViewWishlist = "wishlist"
    static let APIAddWishlist = "wishlist_add"
    static let APILogin = "login"
    static let APIUpdateDeviceToken = "user_logs"
    
    static let APISignup = "signup"
    static let APIForgotPassword = "forget_password"
    static let APILogout = "logout"
    
    static let APIAddCart = "usercart_add"
    static let APIMyCartList = "usercart"
    
    static let APIMyCartDelete = "usercart_delete"
    static let APIMyCartUpdate = "usercart_update"
    static let APIMyCartMoveWishlist = "usercart_move_to_wishlist"
    
    
    static let APIAddAddress = "user_billing_address_add"
    static let APIdeleteAddress = "user_billing_address_delete"
    static let APIEditAddress = "user_billing_address_update"
    static let APIGetAllAddress = "user_billing_address"
    
    static let APIGetAllFreeGift = "giftlist"
    static let APIGetPaymentMode = "paymentmode"
    
    static let APIGetFilterData = "filter_list"
    
    static let APIGetCountryList = "country_list"
    static let APIPayment_by_cod = "payment_by_cod"
    
    
    static let APIMyOrdersList = "orderlist"
    
    
    static let APIPayment_by_tap = "payment_by_tap"
    static let APICMSDetails = "cms_detail"
    
    
    
    static let APIContactDetails = "contact_us"
    static let APISocialDetails = "social"
    static let APIContactQuery = "enquery_form"
    static let APIFAQList = "faq"
    static let APIFAQDetails = "faq_detail"
    
    
    static let APIProfileDetails = "my_profile"
    static let APIProfileEdit = "my_profile_update"
    static let APIChangePassword = "my_profile_password_update"
    static let APIReviewSent = "review_add"
    static let APISortBy = "sort_by"
    static let APIcouponApply = "couponApply"
    static let APIChange_language = "change_language"
    
    
    static let APIGetMyPoints = "totalRedeemPoint"
    static let APIRedeemPoints = "redeemPoint"
    static let APIEarnRedeemPoints = "earn_redeemPoint"
    
    static let APISliderBannerCollection = "brandlistbanners_of_category"
    static let APIGetChildFromBrand = "getchildfrombrand"
    static let APIGuestChecout = "signup_guest"
    
    static let notification_update = "notification_update"
    
    static let APIGetPowerList = "get_power"
    static let APIViewOffers = "offer_brandlist_of_category"
    
    static let APIGetLanchImage = "launcher"
    
}

