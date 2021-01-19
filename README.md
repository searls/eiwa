# eiwa / 英和

Parses two types of Japanese-English dictionaries:

* `:jmdict_e` - [JMDict](http://www.edrdg.org/jmdict/edict_doc.html)'s
  English-only export of the WWWJDIC online Japanese dictionary.
* `:kanjidic2` - the
  [KANJIDIC2](http://www.edrdg.org/wiki/index.php/KANJIDIC_Project) dictionary
  of roughly 13,000 kanji characters

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
the [EDRDG ftp site](http://ftp.edrdg.org/pub/Nihongo/00INDEX.html) or with a
script like this, for the Japanese-English export:

```bash
# Download JMDICT-E:
$ curl http://ftp.edrdg.org/pub/Nihongo/JMdict_e.gz -o jmdict.xml.gz"
# Unzip to jmdict.xml
$ gunzip jmdict.xml.gz

# Download KANJIDIC2:
$ curl http://www.edrdg.org/kanjidic/kanjidic2.xml.gz -o kanjidic2.xml.gz
# Unzip to kanjidic2.xml
$ gunzip kanjidic2.xml.gz
```

These files are updated daily, and are essentially an export of all vocabulary
and kanji in the [WWWJDIC
application](http://nihongo.monash.edu/cgi-bin/wwwjdic?1C)

### Parse the dictionary

The eiwa gem implements an evented [SAX
parser](https://en.wikipedia.org/wiki/Simple_API_for_XML) via nokogiri to
efficiently work through the very large XML file, as loading a full DOM into
memory is very resource-intensive. In consideration of this, eiwa's parsing
method provides two modes, one that will return every dictionary entry in an
array and one that will invoke a provided block with each entry, but which won't
retain a reference to the entries, allowing Ruby to garbage collect them as it
goes.

#### Passing a block

If you just want to do some processing on each entry, it probably makes sense to
invoke the library by passing a block (note that supported types include only
`:jmdict_e` and `:kanjidic2`)

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

