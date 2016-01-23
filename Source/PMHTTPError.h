//
//  PMHTTPError.h
//  PostmatesNetworking
//
//  Created by Kevin Ballard on 1/19/16.
//  Copyright © 2016 Postmates. All rights reserved.
//

@import Foundation;

/// Error domain for \c HTTPManager errors.
extern NSString * const PMHTTPErrorDomain;

/// Error codes for \c HTTPManager errors.
typedef NS_ENUM(NSInteger, PMHTTPError) {
    /// An HTTP response was returned that indicates failure.
    /// @see <tt>PMHTTPStatusCodeErrorKey</tt>, <tt>PMHTTPBodyDataErrorKey</tt>, <tt>PMHTTPBodyJSONErrorKey</tt>.
    PMHTTPErrorFailedResponse = 1,
    /// An HTTP response was returned that had an incorrect Content-Type header.
    /// @see <tt>PMHTTPContentTypeErrorKey</tt>, <tt>PMHTTPBodyDataErrorKey</tt>
    PMHTTPErrorUnexpectedContentType,
    /// An HTTP response returned a 204 No Content where an entity was expected.
    PMHTTPErrorUnexpectedNoContent,
    /// A redirect was encountered while trying to parse a response that has redirects disabled.
    /// @see <tt>PMHTTPStatusCodeErrorKey</tt>, <tt>PMHTTPLocationErrorKey</tt>, <tt>PMHTTPBodyDataErrorKey</tt>.
    PMHTTPErrorUnexpectedRedirect
};

// User info keys

/// The corresponding value is an \c NSNumber with the status code of the response.
/// @see <tt>PMHTTPErrorFailedResponse</tt>, <tt>PMHTTPErrorUnexpectedRedirect</tt>.
extern NSString * const PMHTTPStatusCodeErrorKey;
/// The corresponding value is a \c NSData with the body of the response.
/// @see <tt>PMHTTPErrorFailedResponse</tt>, <tt>PMHTTPErrorUnexpectedContentType</tt>, <tt>PMHTTPErrorUnexpectedRedirect</tt>.
extern NSString * const PMHTTPBodyDataErrorKey;
/// The corresponding value is an \c NSDictionary with the body of the response decoded as JSON.
/// This key may not be present if the response \c Content-Type is not <tt>application/json</tt>,
/// if the JSON decode fails, or if the JSON top-level value is not an object.
/// The dictionary does not include any \c NSNull values.
/// @see <tt>PMHTTPErrorFailedResponse</tt>.
extern NSString * const PMHTTPBodyJSONErrorKey;
/// The corresponding value is a \c NSString with the Content-Type of the response.
/// @see <tt>PMHTTPErrorUnexpectedContentType</tt>.
extern NSString * const PMHTTPContentTypeErrorKey;
/// The corresponding value is an \c NSURL with the Location of the response. May be \c nil.
/// @see <tt>PMHTTPErrorUnexpectedRedirect</tt>.
extern NSString * const PMHTTPLocationErrorKey;