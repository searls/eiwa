# eiwa / 英和

Parses the Japanese-English version of JMDict, a daily export of the WWWJDIC
online Japanese dictionary.

## Usage

### Install

Install the gem:

```
gem install eiwa
```

Or add it to your `Gemfile`:

```ruby
gem 'eiwa'
```

### Download a supported dictionary

Get your hands on a supported dictionary. Right now eiwa only parses
[JMDict](http://www.edrdg.org/jmdict/j_jmdict.html), which can be fetched from
the [Monash ftp site](http://ftp.monash.edu/pub/nihongo/00INDEX.html) or with a
script like this, for the Japanese-English export:

```bash
curl http://ftp.monash.edu/pub/nihongo/JMdict_e -o jmdict.xml
```

This file is updated daily, and is essentially an export of all vocabulary on
the [WWWJDIC application](http://nihongo.monash.edu/cgi-bin/wwwjdic?1C)

### Parse the dictionary

The eiwa gem implements an evented [SAX
parser](https://en.wikipedia.org/wiki/Simple_API_for_XML) via nokogiri to
efficiently work through the very large XML file, as loading a full DOM into
memory is very resource-intensive. In consideration of this, eiwa's parsing
method provides two modes, one that will return every dictionary entry in an
array and one that will invoke a provided block with each entry, but which won't
retain a reference to the entries, allowing Ruby to garbage collect them as it
goes.

Parsing the dictionary is CPU intensive, and takes about 13 seconds on my 2019
13" MacBook Pro.

#### Passing a block

If you just want to do some processing on each entry, it probably makes sense to
invoke the library by passing a block

```ruby
Eiwa.parse_file("path/to/some.xml", type: :jmdict_e) do |entry|
  # Do something with that entry
end
```

This approach can parse the entire JMDICT-E dictionary in a 15MB Ruby 2.6
process.

#### Return the results in an array

If you're just going to add all the entries to an array or otherwise retain them
in memory, you can call the same method without a block, and it will return all
the entries in an array.

```ruby
entries = Eiwa.parse_file("path/to/some.xml", type: :jmdict_e)
```

Note that for the abridged Japanese-English dictionary, this will consume about
500MB of RAM.

### The entry object model

I haven't documented the [Entry](https://github.com/searls/eiwa/blob/master/lib/eiwa/tag/entry.rb) type or its child types yet, but they should be pretty easy to piece together by inspecting the output and [checking the source listings](https://github.com/searls/eiwa/blob/master/lib/eiwa/tag).
