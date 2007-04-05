/*
 * FCKeditor - The text editor for internet
 * Copyright (C) 2003 Frederico Caldeira Knabben
 *
 * Licensed under the terms of the GNU Lesser General Public License
 * (http://www.opensource.org/licenses/lgpl-license.php)
 *
 * For further information go to http://www.fredck.com/FCKeditor/ 
 * or contact fckeditor@fredck.com.
 *
 * fck_lang.js: Handles multi language functionality.
 *
 * Authors:
 *   Frederico Caldeira Knabben (fckeditor@fredck.com)
 */

var lang = new Object() ;

var AvailableLangs = new Object() ;

AvailableLangs["en"]	= true ;
AvailableLangs["ru"]	= true ;

AvailableLangs.GetActiveLanguage = function()
{
	if ( config.AutoDetectLanguage )
	{
		var sUserLang = navigator.userLanguage.toLowerCase() ;
		
		if ( this[sUserLang] ) 
			return sUserLang ;
		else if ( sUserLang.length > 2 )
		{
			sUserLang = sUserLang.substr(0,2) ;
			if ( this[sUserLang] ) 
				return sUserLang ;
		}
	}
	
	return config.DefaultLanguage ;
}

document.write('<script src="/i/rte/lang/' + AvailableLangs.GetActiveLanguage() + '.js" type="text/javascript"><\/script>') ;

AvailableLangs.TranslatePage = function( targetDocument )
{
	// Gets all INPUT elements and translate then values
	var aInputs = targetDocument.getElementsByTagName("INPUT") ;
	for ( i = 0 ; i < aInputs.length ; i++ )
	{
		if ( aInputs[i].fckLang )
			aInputs[i].value = lang[ aInputs[i].fckLang ] ;
	}

	// Gets all SPAN elements and translate then cotents
	var aSpans = targetDocument.getElementsByTagName("SPAN") ;
	for ( i = 0 ; i < aSpans.length ; i++ )
	{
		if ( aSpans[i].fckLang )
			aSpans[i].innerText = lang[ aSpans[i].fckLang ] ;
	}
	
	// Gets all OPTION elements and translate then cotents
	var aOptions = targetDocument.getElementsByTagName("OPTION") ;
	for ( i = 0 ; i < aOptions.length ; i++ )
	{
		if ( aOptions[i].fckLang )
			aOptions[i].innerText = lang[ aOptions[i].fckLang ] ;
	}
}