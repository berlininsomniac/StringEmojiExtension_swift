//
//  String+Emojis.h
//  StringEmojiExtension
//
//  Created by Benjamin Salanki on 2018. 06. 11.
//  Copyright © 2018. Totally Inappropriate Technologies. All rights reserved.
//

import UIKit
import Foundation

extension String {
	
	/**
		Generates and returns a String containing a regular expression that finds the ranges in the string that contain only emojis.
	*/

	static let emojiRegexString: String = {
		
		var unicodeRanges = [String]()
		
		// Characters are defined in UTF-32 HEX.

		unicodeRanges.append("\\U0001F600-\\U0001F64F") // Emoticons
		unicodeRanges.append("\\U0001F300-\\U0001F5FF") // Misc Symbols and Pictographs
		unicodeRanges.append("\\U0001F680-\\U0001F6FF") // Transport and Map
		unicodeRanges.append("\\U0001F1E6-\\U0001F1FF") // Flags
		unicodeRanges.append("\\U00002600-\\U000026FF") // Misc symbols
		unicodeRanges.append("\\U00002700-\\U000027BF") // Dingbats
		unicodeRanges.append("\\U0000FE00-\\U0000FE0F") // Variation Selectors
		unicodeRanges.append("\\U00065024-\\U00065039") // Variation Selectors (continued)
		unicodeRanges.append("\\U0001F900-\\U0001F9FF") // Supplemental Symbols and Pictographs
		unicodeRanges.append("\\U00008400-\\U00008447") // Han Characters
		unicodeRanges.append("\\U00009100-\\U00009300") // Han Characters (continued)
		unicodeRanges.append("\\U00002194-\\U00002199") // Arrows
		unicodeRanges.append("\\U000023E9-\\U000023FA") // Controller buttons and Clocks
		unicodeRanges.append("\\U000025FB-\\U000025FE") // Colored Squares
		unicodeRanges.append("\\U0001F191-\\U0001F19A") // Squared
		unicodeRanges.append("\\U0001F232-\\U0001F23A") // Squared CJK
		unicodeRanges.append("\\U000000A9\\U000000AE\\U0000203C\\U00002049\\U00002122\\U00002139\\U000021A9\\U000021AA\\U0000231A") // Items not fitting in ranges
		unicodeRanges.append("\\U0000231B\\U00002328\\U000023CF\\U000023E9\\U000024C2\\U000025AA\\U000025AB\\U000025B6\\U000025C0") // Items not fitting in ranges (continued)
		unicodeRanges.append("\\U0001F170\\U0001F171\\U0001F17E\\U0001F17F\\U0001F18E\\U0001F004\\U0001F201\\U0001F202\\U00003030") // Items not fitting in ranges (continued)
		unicodeRanges.append("\\U0000303D\\U00003297\\U00003299\\U00002934\\U00002935\\U00002B05\\U00002B06\\U00002B07\\U00002B1B") // Items not fitting in ranges (continued)
		unicodeRanges.append("\\U00002B1C\\U00002B50\\U00002B55\\U0001F21A\\U0001F22F\\U0001F250\\U0001F251") // Items not fitting in ranges (continued)
		unicodeRanges.append("[(\\*|\\#|0-9)\\U000020E3]") // Number values suffixed with a keycap. Yeah. Exactly.
		unicodeRanges.append("\\U0000200D") // Non-breaking space
		
		return "[" + unicodeRanges.joined() + "]+"
	}()
	
	/**
		NSRegularExpression for finding emoji ranges in a string.
	*/
	
	static let emojiRegex: NSRegularExpression = try! NSRegularExpression.init(pattern: emojiRegexString, options: .caseInsensitive)
	
	func emojiRanges() -> Array<NSValue> {
		return String.emojiRegex.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.utf16.count)).map { value -> NSValue in
			NSValue(range: value.range)
		}
	}
	
	/**
		Checks wether the receiver consist solely of emojis.
	*/
	
	func containsOnlyEmojis() -> Bool {
		
		guard self.count > 0 else {
			return false
		}
		
		let emojiRanges = self.emojiRanges()
		let firstEmojiRange = emojiRanges.first?.rangeValue
		
		if let firstEmojiRange = firstEmojiRange, emojiRanges.count == 1 {
			
			return firstEmojiRange.location == 0 && firstEmojiRange.length == self.utf16.count
		} else {
			return false
		}
	}
	
	/*
		Creates a new String by stripping the emojis from the receiver.
	*/
	
	func stringByStrippingEmojis() -> String {

		var stringByStrippingEmojis = String(self)

		let matches = stringByStrippingEmojis.emojiRanges()

		for range in matches.map({ value -> NSRange in
			value.rangeValue
		}).reversed() {
			stringByStrippingEmojis.replaceSubrange(Range(range, in: self)!, with: "")
		}

		return stringByStrippingEmojis
	}
}
