/*
 * Holds procs designed to help with filtering text
 * Contains groups:
 *			SQL sanitization
 *			Text sanitization
 *			Text searches
 *			Text modification
 *			Misc
 */


/*
 * SQL sanitization
 */

// Run all strings to be used in an SQL query through this proc first to properly escape out injection attempts.
/proc/sanitizeSQL(var/t as text)
	var/sqltext = dbcon.Quote(t);
	return copytext(sqltext, 2, lentext(sqltext));//Quote() adds quotes around input, we already do that

/*
 * Text sanitization
 */

proc/fix_html(var/t)
	return replacetext(t, "�", "&#1103;")

//Used for preprocessing entered text
//Added in an additional check to alert players if input is too long
/proc/sanitize(var/input, var/max_length = MAX_MESSAGE_LEN, var/encode = 1, var/trim = 1, var/extra = 1)
	if(!input)
		return

	if(max_length)
		//testing shows that just looking for > max_length alone will actually cut off the final character if message is precisely max_length, so >= instead
		if(length(input) >= max_length)
			var/overflow = ((length(input)+1) - max_length)
			to_chat(usr, "<span class='warning'>Your message is too long by [overflow] character\s.</span>")
			return
		input = copytext(input,1,max_length)

	input = replace_characters(input, list("�"="___255_"))

	if(extra)
		input = replace_characters(input, list("\n"=" ","\t"=" "))

	if(encode)
		// The below \ escapes have a space inserted to attempt to enable Travis auto-checking of span class usage. Please do not remove the space.
		//In addition to processing html, html_encode removes byond formatting codes like "\ red", "\ i" and other.
		//It is important to avoid double-encode text, it can "break" quotes and some other characters.
		//Also, keep in mind that escaped characters don't work in the interface (window titles, lower left corner of the main window, etc.)
		input = html_encode(input)
	else
		//If not need encode text, simply remove < and >
		//note: we can also remove here byond formatting codes: 0xFF + next byte
		input = replace_characters(input, list("<"=" ", ">"=" "))

	if(trim)
		//Maybe, we need trim text twice? Here and before copytext?
		input = trim(input)

	input = replace_characters(input, list("___255_"="&#255;"))

	return input

//Run sanitize(), but remove <, >, " first to prevent displaying them as &gt; &lt; &34; in some places, after html_encode().
//Best used for sanitize object names, window titles.
//If you have a problem with sanitize() in chat, when quotes and >, < are displayed as html entites -
//this is a problem of double-encode(when & becomes &amp;), use sanitize() with encode=0, but not the sanitizeSafe()!
/proc/sanitizeSafe(var/input, var/max_length = MAX_MESSAGE_LEN, var/encode = 1, var/trim = 1, var/extra = 1)
	return sanitize(replace_characters(input, list(">"=" ","<"=" ", "\""="'")), max_length, encode, trim, extra)

//Filters out undesirable characters from names
/proc/sanitizeName(var/input, var/max_length = MAX_NAME_LEN, var/allow_numbers = 0, var/force_first_letter_uppercase = TRUE)
	if(!input || length(input) > max_length)
		return //Rejects the input if it is null or if it is longer then the max length allowed

	var/number_of_alphanumeric	= 0
	var/last_char_group			= 0
	var/output = ""

	for(var/i=1, i<=length(input), i++)
		var/ascii_char = text2ascii(input,i)
		switch(ascii_char)
			// A  .. Z
			if(65 to 90)			//Uppercase Letters
				output += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_group = 4

			// a  .. z
			if(97 to 122)			//Lowercase Letters
				if(last_char_group<2 && force_first_letter_uppercase)
					output += ascii2text(ascii_char-32)	//Force uppercase first character
				else
					output += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_group = 4

			// 0  .. 9
			if(48 to 57)			//Numbers
				if(!last_char_group)		continue	//suppress at start of string
				if(!allow_numbers)			continue
				output += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_group = 3

			// '  -  .
			if(39,45,46)			//Common name punctuation
				if(!last_char_group) continue
				output += ascii2text(ascii_char)
				last_char_group = 2

			// ~   |   @  :  #  $  %  &  *  +
			if(126,124,64,58,35,36,37,38,42,43)			//Other symbols that we'll allow (mainly for AI)
				if(!last_char_group)		continue	//suppress at start of string
				if(!allow_numbers)			continue
				output += ascii2text(ascii_char)
				last_char_group = 2

			//Space
			if(32)
				if(last_char_group <= 1)	continue	//suppress double-spaces and spaces at start of string
				output += ascii2text(ascii_char)
				last_char_group = 1
			else
				return

	if(number_of_alphanumeric < 2)	return		//protects against tiny names like "A" and also names like "' ' ' ' ' ' ' '"

	if(last_char_group == 1)
		output = copytext(output,1,length(output))	//removes the last character (in this case a space)

	for(var/bad_name in list("space","floor","wall","r-wall","monkey","unknown","inactive ai","plating"))	//prevents these common metagamey names
		if(cmptext(output,bad_name))	return	//(not case sensitive)

	return output

//Returns null if there is any bad text in the string
/proc/reject_bad_text(var/text, var/max_length=512)
	if(length(text) > max_length)	return			//message too long
	var/non_whitespace = 0
	for(var/i=1, i<=length(text), i++)
		switch(text2ascii(text,i))
			if(62,60,92,47)	return			//rejects the text if it contains these bad characters: <, >, \ or /
			if(0 to 31)		return			//more weird stuff
			if(32)			continue		//whitespace
			else			non_whitespace = 1
	if(non_whitespace)		return text		//only accepts the text if it has some non-spaces


//Old variant. Haven't dared to replace in some places.
/proc/sanitize_old(var/t,var/list/repl_chars = list("�"="___255_"))
	return replacetext(html_encode(replace_characters(t,repl_chars)), "___255_", "&#255;")

/*
 * Text searches
 */

//Checks the beginning of a string for a specified sub-string
//Returns the position of the substring or 0 if it was not found
/proc/dd_hasprefix(text, prefix)
	var/start = 1
	var/end = length(prefix) + 1
	return findtext(text, prefix, start, end)

//Checks the beginning of a string for a specified sub-string. This proc is case sensitive
//Returns the position of the substring or 0 if it was not found
/proc/dd_hasprefix_case(text, prefix)
	var/start = 1
	var/end = length(prefix) + 1
	return findtextEx(text, prefix, start, end)

//Checks the end of a string for a specified substring.
//Returns the position of the substring or 0 if it was not found
/proc/dd_hassuffix(text, suffix)
	var/start = length(text) - length(suffix)
	if(start)
		return findtext(text, suffix, start, null)
	return

//Checks the end of a string for a specified substring. This proc is case sensitive
//Returns the position of the substring or 0 if it was not found
/proc/dd_hassuffix_case(text, suffix)
	var/start = length(text) - length(suffix)
	if(start)
		return findtextEx(text, suffix, start, null)

/*
 * Text modification
 */

/proc/replace_characters(var/t,var/list/repl_chars)
	for(var/char in repl_chars)
		t = replacetext(t, char, repl_chars[char])
	return t

//Adds 'u' number of zeros ahead of the text 't'
/proc/add_zero(t, u)
	while (length(t) < u)
		t = "0[t]"
	return t

//Adds 'u' number of spaces ahead of the text 't'
/proc/add_lspace(t, u)
	while(length(t) < u)
		t = " [t]"
	return t

//Adds 'u' number of spaces behind the text 't'
/proc/add_tspace(t, u)
	while(length(t) < u)
		t = "[t] "
	return t

//Returns a string with reserved characters and spaces before the first letter removed
/proc/trim_left(text)
	for (var/i = 1 to length(text))
		if (text2ascii(text, i) > 32)
			return copytext(text, i)
	return ""

//Returns a string with reserved characters and spaces after the last letter removed
/proc/trim_right(text)
	for (var/i = length(text), i > 0, i--)
		if (text2ascii(text, i) > 32)
			return copytext(text, 1, i + 1)
	return ""

//Returns a string with reserved characters and spaces before the first word and after the last word removed.
/proc/trim(text)
	return trim_left(trim_right(text))

//Returns a string with the first element of the string capitalized.
/proc/capitalize(var/t as text)
	return uppertext(copytext(t, 1, 2)) + copytext(t, 2)

//This proc strips html properly, remove < > and all text between
//for complete text sanitizing should be used sanitize()
/proc/strip_html_properly(var/input)
	if(!input)
		return
	var/opentag = 1 //These store the position of < and > respectively.
	var/closetag = 1
	while(1)
		opentag = findtext(input, "<")
		closetag = findtext(input, ">")
		if(closetag && opentag)
			if(closetag < opentag)
				input = copytext(input, (closetag + 1))
			else
				input = copytext(input, 1, opentag) + copytext(input, (closetag + 1))
		else if(closetag || opentag)
			if(opentag)
				input = copytext(input, 1, opentag)
			else
				input = copytext(input, (closetag + 1))
		else
			break

	return input

//This proc fills in all spaces with the "replace" var (* by default) with whatever
//is in the other string at the same spot (assuming it is not a replace char).
//This is used for fingerprints
/proc/stringmerge(var/text,var/compare,replace = "*")
	var/newtext = text
	if(lentext(text) != lentext(compare))
		return 0
	for(var/i = 1, i < lentext(text), i++)
		var/a = copytext(text,i,i+1)
		var/b = copytext(compare,i,i+1)
		//if it isn't both the same letter, or if they are both the replacement character
		//(no way to know what it was supposed to be)
		if(a != b)
			if(a == replace) //if A is the replacement char
				newtext = copytext(newtext,1,i) + b + copytext(newtext, i+1)
			else if(b == replace) //if B is the replacement char
				newtext = copytext(newtext,1,i) + a + copytext(newtext, i+1)
			else //The lists disagree, Uh-oh!
				return 0
	return newtext

//This proc returns the number of chars of the string that is the character
//This is used for detective work to determine fingerprint completion.
/proc/stringpercent(var/text,character = "*")
	if(!text || !character)
		return 0
	var/count = 0
	for(var/i = 1, i <= lentext(text), i++)
		var/a = copytext(text,i,i+1)
		if(a == character)
			count++
	return count

/proc/reverse_text(var/text = "")
	var/new_text = ""
	for(var/i = length(text); i > 0; i--)
		new_text += copytext(text, i, i+1)
	return new_text

//Used in preferences' SetFlavorText and human's set_flavor verb
//Previews a string of len or less length
proc/TextPreview(var/string,var/len=40)
	if(lentext(string) <= len)
		if(!lentext(string))
			return "\[...\]"
		else
			return string
	else
		return "[copytext_preserve_html(string, 1, 37)]..."

//alternative copytext() for encoded text, doesn't break html entities (&#34; and other)
/proc/copytext_preserve_html(var/text, var/first, var/last)
	var/temp = replacetextEx(text, "&#255;", "�")
	temp = replacetextEx(temp, "&#1103;", "�")
	var/delta = length(text) - length(temp)
	if(delta < 0)
		delta = 0
	var/msg = html_encode(copytext(html_decode(text), first, last + delta))
	msg = replacetextEx(msg, "&amp;#255;", "&#255;")
	msg = replacetextEx(msg, "&amp;#1103;", "&#1103;")
	return msg

//For generating neat chat tag-images
//The icon var could be local in the proc, but it's a waste of resources
//	to always create it and then throw it out.
/var/icon/text_tag_icons = new('./icons/chattags.dmi')
/proc/create_text_tag(var/tagname, var/tagdesc = tagname, var/client/C = null)
	if(!(C && C.get_preference_value(/datum/client_preference/chat_tags) == GLOB.PREF_SHOW))
		return tagdesc
	return "<IMG src='\ref[text_tag_icons.icon]' class='text_tag' iconstate='[tagname]'" + (tagdesc ? " alt='[tagdesc]'" : "") + ">"

/proc/contains_az09(var/input)
	for(var/i=1, i<=length(input), i++)
		var/ascii_char = text2ascii(input,i)
		switch(ascii_char)
			// A  .. Z
			if(65 to 90)			//Uppercase Letters
				return 1
			// a  .. z
			if(97 to 122)			//Lowercase Letters
				return 1

			// 0  .. 9
			if(48 to 57)			//Numbers
				return 1
	return 0

//unicode sanitization
/proc/sanitize_u(t)
	t = html_encode(sanitize(t))
	t = replacetext(t, "____255_", "&#1103;")
	return t

//convertion cp1251 to unicode
/proc/sanitize_a2u(t)
	t = replacetext(t, "&#255;", "&#1103;")
	return t

//convertion unicode to cp1251
/proc/sanitize_u2a(t)
	t = replacetext(t, "&#1103;", "&#255;")
	return t

//clean sanitize cp1251
/proc/sanitize_a0(t)
	t = replacetext(t, "�", "&#255;")
	return t

//clean sanitize unicode
/proc/sanitize_u0(t)
	t = replacetext(t, "�", "&#1103;")
	return t

/proc/remore_cyrillic(t)
	var/list/symbols = list("�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", \
	"�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", \
	"�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", \
	"�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�")
	for(var/i in symbols)
		t = replacetext(t, i, "")
	return t
var/list/alphabet = list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
/proc/extA2U(t)
	if(DM_VERSION < 511)
		//�, �
		t = replacetextEx(t, "\\xa8", "\\u0401")
		t = replacetextEx(t, "\\xb8", "\\u0451")
		//�-�
		t = replacetextEx(t, "\\xc0", "\\u0410")
		t = replacetextEx(t, "\\xc1", "\\u0411")
		t = replacetextEx(t, "\\xc2", "\\u0412")
		t = replacetextEx(t, "\\xc3", "\\u0413")
		t = replacetextEx(t, "\\xc4", "\\u0414")
		t = replacetextEx(t, "\\xc5", "\\u0415")
		t = replacetextEx(t, "\\xc6", "\\u0416")
		t = replacetextEx(t, "\\xc7", "\\u0417")
		t = replacetextEx(t, "\\xc8", "\\u0418")
		t = replacetextEx(t, "\\xc9", "\\u0419")
		t = replacetextEx(t, "\\xca", "\\u041a")
		t = replacetextEx(t, "\\xcb", "\\u041b")
		t = replacetextEx(t, "\\xcc", "\\u041c")
		t = replacetextEx(t, "\\xcd", "\\u041d")
		t = replacetextEx(t, "\\xce", "\\u041e")
		t = replacetextEx(t, "\\xcf", "\\u041f")
		//�-�
		t = replacetextEx(t, "\\xd0", "\\u0420")
		t = replacetextEx(t, "\\xd1", "\\u0421")
		t = replacetextEx(t, "\\xd2", "\\u0422")
		t = replacetextEx(t, "\\xd3", "\\u0423")
		t = replacetextEx(t, "\\xd4", "\\u0424")
		t = replacetextEx(t, "\\xd5", "\\u0425")
		t = replacetextEx(t, "\\xd6", "\\u0426")
		t = replacetextEx(t, "\\xd7", "\\u0427")
		t = replacetextEx(t, "\\xd8", "\\u0428")
		t = replacetextEx(t, "\\xd9", "\\u0429")
		t = replacetextEx(t, "\\xda", "\\u042a")
		t = replacetextEx(t, "\\xdb", "\\u042b")
		t = replacetextEx(t, "\\xdc", "\\u042c")
		t = replacetextEx(t, "\\xdd", "\\u042d")
		t = replacetextEx(t, "\\xde", "\\u042e")
		t = replacetextEx(t, "\\xdf", "\\u042f")
		//�-�
		t = replacetextEx(t, "\\xe0", "\\u0430")
		t = replacetextEx(t, "\\xe1", "\\u0431")
		t = replacetextEx(t, "\\xe2", "\\u0432")
		t = replacetextEx(t, "\\xe3", "\\u0433")
		t = replacetextEx(t, "\\xe4", "\\u0434")
		t = replacetextEx(t, "\\xe5", "\\u0435")
		t = replacetextEx(t, "\\xe6", "\\u0436")
		t = replacetextEx(t, "\\xe7", "\\u0437")
		t = replacetextEx(t, "\\xe8", "\\u0438")
		t = replacetextEx(t, "\\xe9", "\\u0439")
		t = replacetextEx(t, "\\xea", "\\u043a")
		t = replacetextEx(t, "\\xeb", "\\u043b")
		t = replacetextEx(t, "\\xec", "\\u043c")
		t = replacetextEx(t, "\\xed", "\\u043d")
		t = replacetextEx(t, "\\xee", "\\u043e")
		t = replacetextEx(t, "\\xef", "\\u043f")
		//�-�
		t = replacetextEx(t, "\\xf0", "\\u0440")
		t = replacetextEx(t, "\\xf1", "\\u0441")
		t = replacetextEx(t, "\\xf2", "\\u0442")
		t = replacetextEx(t, "\\xf3", "\\u0443")
		t = replacetextEx(t, "\\xf4", "\\u0444")
		t = replacetextEx(t, "\\xf5", "\\u0445")
		t = replacetextEx(t, "\\xf6", "\\u0446")
		t = replacetextEx(t, "\\xf7", "\\u0447")
		t = replacetextEx(t, "\\xf8", "\\u0448")
		t = replacetextEx(t, "\\xf9", "\\u0449")
		t = replacetextEx(t, "\\xfa", "\\u044a")
		t = replacetextEx(t, "\\xfb", "\\u044b")
		t = replacetextEx(t, "\\xfc", "\\u044c")
		t = replacetextEx(t, "\\xfd", "\\u044d")
		t = replacetextEx(t, "\\xfe", "\\u044e")
	else
		//�, �
		t = replacetextEx(t, "\\u00a8", "\\u0401")
		t = replacetextEx(t, "\\u00b8", "\\u0451")
		//�-�
		t = replacetextEx(t, "\\u00c0", "\\u0410")
		t = replacetextEx(t, "\\u00c1", "\\u0411")
		t = replacetextEx(t, "\\u00c2", "\\u0412")
		t = replacetextEx(t, "\\u00c3", "\\u0413")
		t = replacetextEx(t, "\\u00c4", "\\u0414")
		t = replacetextEx(t, "\\u00c5", "\\u0415")
		t = replacetextEx(t, "\\u00c6", "\\u0416")
		t = replacetextEx(t, "\\u00c7", "\\u0417")
		t = replacetextEx(t, "\\u00c8", "\\u0418")
		t = replacetextEx(t, "\\u00c9", "\\u0419")
		t = replacetextEx(t, "\\u00ca", "\\u041a")
		t = replacetextEx(t, "\\u00cb", "\\u041b")
		t = replacetextEx(t, "\\u00cc", "\\u041c")
		t = replacetextEx(t, "\\u00cd", "\\u041d")
		t = replacetextEx(t, "\\u00ce", "\\u041e")
		t = replacetextEx(t, "\\u00cf", "\\u041f")
		//�-�
		t = replacetextEx(t, "\\u00d0", "\\u0420")
		t = replacetextEx(t, "\\u00d1", "\\u0421")
		t = replacetextEx(t, "\\u00d2", "\\u0422")
		t = replacetextEx(t, "\\u00d3", "\\u0423")
		t = replacetextEx(t, "\\u00d4", "\\u0424")
		t = replacetextEx(t, "\\u00d5", "\\u0425")
		t = replacetextEx(t, "\\u00d6", "\\u0426")
		t = replacetextEx(t, "\\u00d7", "\\u0427")
		t = replacetextEx(t, "\\u00d8", "\\u0428")
		t = replacetextEx(t, "\\u00d9", "\\u0429")
		t = replacetextEx(t, "\\u00da", "\\u042a")
		t = replacetextEx(t, "\\u00db", "\\u042b")
		t = replacetextEx(t, "\\u00dc", "\\u042c")
		t = replacetextEx(t, "\\u00dd", "\\u042d")
		t = replacetextEx(t, "\\u00de", "\\u042e")
		t = replacetextEx(t, "\\u00df", "\\u042f")
		//�-�
		t = replacetextEx(t, "\\u00e0", "\\u0430")
		t = replacetextEx(t, "\\u00e1", "\\u0431")
		t = replacetextEx(t, "\\u00e2", "\\u0432")
		t = replacetextEx(t, "\\u00e3", "\\u0433")
		t = replacetextEx(t, "\\u00e4", "\\u0434")
		t = replacetextEx(t, "\\u00e5", "\\u0435")
		t = replacetextEx(t, "\\u00e6", "\\u0436")
		t = replacetextEx(t, "\\u00e7", "\\u0437")
		t = replacetextEx(t, "\\u00e8", "\\u0438")
		t = replacetextEx(t, "\\u00e9", "\\u0439")
		t = replacetextEx(t, "\\u00ea", "\\u043a")
		t = replacetextEx(t, "\\u00eb", "\\u043b")
		t = replacetextEx(t, "\\u00ec", "\\u043c")
		t = replacetextEx(t, "\\u00ed", "\\u043d")
		t = replacetextEx(t, "\\u00ee", "\\u043e")
		t = replacetextEx(t, "\\u00ef", "\\u043f")
		//�-�
		t = replacetextEx(t, "\\u00f0", "\\u0440")
		t = replacetextEx(t, "\\u00f1", "\\u0441")
		t = replacetextEx(t, "\\u00f2", "\\u0442")
		t = replacetextEx(t, "\\u00f3", "\\u0443")
		t = replacetextEx(t, "\\u00f4", "\\u0444")
		t = replacetextEx(t, "\\u00f5", "\\u0445")
		t = replacetextEx(t, "\\u00f6", "\\u0446")
		t = replacetextEx(t, "\\u00f7", "\\u0447")
		t = replacetextEx(t, "\\u00f8", "\\u0448")
		t = replacetextEx(t, "\\u00f9", "\\u0449")
		t = replacetextEx(t, "\\u00fa", "\\u044a")
		t = replacetextEx(t, "\\u00fb", "\\u044b")
		t = replacetextEx(t, "\\u00fc", "\\u044c")
		t = replacetextEx(t, "\\u00fd", "\\u044d")
		t = replacetextEx(t, "\\u00fe", "\\u044e")
	t = replacetextEx(t, "&amp;#255;", "\\u044f")
	t = replacetextEx(t, "&amp;#1103;", "\\u044f")
	t = replacetextEx(t, "&#255;", "\\u044f")
	t = replacetextEx(t, "&#1103;", "\\u044f")
	return t

/proc/generateRandomString(var/length)
	. = list()
	for(var/a in 1 to length)
		var/letter = rand(33,126)
		. += ascii2text(letter)
	. = jointext(.,null)

#define starts_with(string, substring) (copytext(string,1,1+length(substring)) == substring)

#define gender2text(gender) capitalize(gender)

/**
 * Strip out the special beyond characters for \proper and \improper
 * from text that will be sent to the browser.
 */
#define strip_improper(input_text) replacetext(replacetext(input_text, "\proper", ""), "\improper", "")

/proc/pencode2html(t)
	t = replacetext(t, "\n", "<BR>")
	t = replacetext(t, "\[center\]", "<center>")
	t = replacetext(t, "\[/center\]", "</center>")
	t = replacetext(t, "\[br\]", "<BR>")
	t = replacetext(t, "\[b\]", "<B>")
	t = replacetext(t, "\[/b\]", "</B>")
	t = replacetext(t, "\[i\]", "<I>")
	t = replacetext(t, "\[/i\]", "</I>")
	t = replacetext(t, "\[u\]", "<U>")
	t = replacetext(t, "\[/u\]", "</U>")
	t = replacetext(t, "\[time\]", "[stationtime2text()]")
	t = replacetext(t, "\[date\]", "[stationdate2text()]")
	t = replacetext(t, "\[large\]", "<font size=\"4\">")
	t = replacetext(t, "\[/large\]", "</font>")
	t = replacetext(t, "\[field\]", "<span class=\"paper_field\"></span>")
	t = replacetext(t, "\[h1\]", "<H1>")
	t = replacetext(t, "\[/h1\]", "</H1>")
	t = replacetext(t, "\[h2\]", "<H2>")
	t = replacetext(t, "\[/h2\]", "</H2>")
	t = replacetext(t, "\[h3\]", "<H3>")
	t = replacetext(t, "\[/h3\]", "</H3>")
	t = replacetext(t, "\[*\]", "<li>")
	t = replacetext(t, "\[hr\]", "<HR>")
	t = replacetext(t, "\[small\]", "<font size = \"1\">")
	t = replacetext(t, "\[/small\]", "</font>")
	t = replacetext(t, "\[list\]", "<ul>")
	t = replacetext(t, "\[/list\]", "</ul>")
	t = replacetext(t, "\[table\]", "<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>")
	t = replacetext(t, "\[/table\]", "</td></tr></table>")
	t = replacetext(t, "\[grid\]", "<table>")
	t = replacetext(t, "\[/grid\]", "</td></tr></table>")
	t = replacetext(t, "\[row\]", "</td><tr>")
	t = replacetext(t, "\[cell\]", "<td>")
	t = replacetext(t, "\[logo\]", "<img src = ntlogo.png>")
	t = replacetext(t, "&#255;", "&#1103;")
	t = replacetext(t, "\[bluelogo\]", "<img src = bluentlogo.png>")
	t = replacetext(t, "\[solcrest\]", "<img src = sollogo.png>")
	t = replacetext(t, "\[terraseal\]", "<img src = terralogo.png>")
	t = replacetext(t, "\[editorbr\]", "")
	t = replacetext(t, "\[img\]","<img src=\"")
	t = replacetext(t, "\[/img\]", "\" />")
	return t

// Random password generator
/proc/GenerateKey()
	//Feel free to move to Helpers.
	var/newKey
	newKey += pick("the", "if", "of", "as", "in", "a", "you", "from", "to", "an", "too", "little", "snow", "dead", "drunk", "rosebud", "duck", "al", "le")
	newKey += pick("diamond", "beer", "mushroom", "assistant", "clown", "captain", "twinkie", "security", "nuke", "small", "big", "escape", "yellow", "gloves", "monkey", "engine", "nuclear", "ai")
	newKey += pick("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	return newKey

//Used for applying byonds text macros to strings that are loaded at runtime
/proc/apply_text_macros(string)
	var/next_backslash = findtext(string, "\\")
	if(!next_backslash)
		return string

	var/leng = length(string)

	var/next_space = findtext(string, " ", next_backslash + 1)
	if(!next_space)
		next_space = leng - next_backslash

	if(!next_space)	//trailing bs
		return string

	var/base = next_backslash == 1 ? "" : copytext(string, 1, next_backslash)
	var/macro = lowertext(copytext(string, next_backslash + 1, next_space))
	var/rest = next_backslash > leng ? "" : copytext(string, next_space + 1)

	//See http://www.byond.com/docs/ref/info.html#/DM/text/macros
	switch(macro)
		//prefixes/agnostic
		if("the")
			rest = text("\the []", rest)
		if("a")
			rest = text("\a []", rest)
		if("an")
			rest = text("\an []", rest)
		if("proper")
			rest = text("\proper []", rest)
		if("improper")
			rest = text("\improper []", rest)
		if("roman")
			rest = text("\roman []", rest)
		//postfixes
		if("th")
			base = text("[]\th", rest)
		if("s")
			base = text("[]\s", rest)
		if("he")
			base = text("[]\he", rest)
		if("she")
			base = text("[]\she", rest)
		if("his")
			base = text("[]\his", rest)
		if("himself")
			base = text("[]\himself", rest)
		if("herself")
			base = text("[]\herself", rest)
		if("hers")
			base = text("[]\hers", rest)

	. = base
	if(rest)
		. += .(rest)

/proc/deep_string_equals(var/A, var/B)
	if (lentext(A) != lentext(B))
		return FALSE
	for (var/i = 1 to lentext(A))
		if (text2ascii(A, i) != text2ascii(B, i))
			return FALSE
	return TRUE