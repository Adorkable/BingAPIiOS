BingAPI
===

[![Pod Version](http://img.shields.io/cocoapods/v/BingAPI.svg?style=flat)](http://cocoadocs.org/docsets/BingAPI/)
[![Pod Platform](http://img.shields.io/cocoapods/p/BingAPI.svg?style=flat)](http://cocoadocs.org/docsets/BingAPI/)
[![Pod License](http://img.shields.io/cocoapods/l/BingAPI.svg?style=flat)](http://cocoadocs.org/docsets/BingAPI/)
[![Build Status](http://img.shields.io/travis/Adorkable/BingAPIiOS.svg?branch=master&style=flat)](https://travis-ci.org/Adorkable/BingAPIiOS)

**BingAPI** a simple iOS library for accessing the Bing/Azure API.

Current Support:

* Search

Installation
---
---
**BingAPI** is available through **[cocoapods](http://cocoapods.org)**, to install simple add the following line to your `PodFile`:

``` ruby
  pod "BingAPI"
```

Alternatively you can add the **[github repo](https://github.com/Adorkable/BingAPIiOS)** as a submodule and use **BingAPI** as a framework.

Setup
---
---
Once you've installed the library

* Create an instance of the `Bing` object by providing it your *Account Key*

``` swift
	var bing = Bing("asdfasdfasdfasdfasdf")
```

Usage
---
**Search**

To Search use the `search` function:

``` swift
	bing.search("xbox", timeoutInterval: timeoutInterval, resultsHandler: { (results : Array<BingSearchResults>?, error) -> Void in
	   ...	
    }
```

**Search Suggest**

To get Search Suggestions use the 'searchSuggest' function:

``` swift
	bing.searchSuggest("xbox", timeoutInterval: timeoutInterval, resultsHandler: { (results : Array<String>?, error) -> Void in
	   ...	
    }
```

Contributing
---
If you have any ideas, suggestions or bugs to report please [create an issue](https://github.com/Adorkable/BingAPIiOS/issues/new) labeled *feature* or *bug* (check to see if the issue exists first please!). Or suggest a pull request!
