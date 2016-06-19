# pandoc-build

This is home to a small script, [pandoc-build.sh](bin/pandoc-build.sh), that can build properly referenced pdfs and/or presentations from source Markdown. [Here](https://github.com/glowkeeper/Markdown-with-References) is an explanation of that. 

To use [pandoc-build.sh](bin/pandoc-build.sh), clone this repository onto a Mac (it probably works on 'nix's too, but I've not verified that) then follow the instructions below.

## Dependencies

Ensure the following dependencies are met.

### General Dependencies

You'll need the following software:

+ [pandoc](https://github.com/jgm/pandoc/releases/download/1.17.0.2/pandoc-1.17.0.2-osx.pkg "pandoc").
+ A LaTex processor. The [BasicTex](http://tug.org/cgi-bin/mactex-download/BasicTeX.pkg "BasicTex") package will suffice. 

### Paper Dependencies

The paper relies on BibTex references. Hence, you'll need:

+ A reference manager that can output [BibTeX](http://www.bibtex.org/). I use [Zotero](https://www.zotero.org/). It works best with [Firefox](https://www.mozilla.org/en-GB/firefox/new/) and [Firefox's Zotero plugin](https://download.zotero.org/extension/zotero-4.0.29.10.xpi). Additionally, I use Zotero's [Better BibText](https://github.com/retorquere/zotero-better-bibtex) plugin, primarily because that helps avoid citation key clashes. 
+ A [Citation Style Language](http://citationstyles.org/) (CSL) file that matches the citation style you need. The [Zotero Style Repository](https://www.zotero.org/styles) has many such files. I often have to produce IEEE citations, for which I use the file [IEEE with URL](https://www.zotero.org/styles/ieee-with-url).
+ Images should be refenced this way in your Markdown: `![Image](images/image.jpg "Image")`

### Presentation Dependencies

You'll need:

+ [reveal.js](https://github.com/hakimel/reveal.js/)
+ A CSS file for styling your presentation. e.g:

	<style type="text/css"><br>
	  .reveal .slides { margin-top: 40px; }<br>
	  .reveal .slides li { font-size: 1.1em; }<br>
	  .reveal p { font-size: 1.1em; }<br>
	</style><br>

+ Images should be refenced this way in your Markdown: `![](images/image.png)`

### Modify your PATH Variable

The pandoc and LaTex must be in your your `$PATH`; e.g `export PATH=$PATH:/usr/local/bin:/usr/texbin`.

## Creating PDF's

Providing all the dependencies have been satisfied, the script `bin/pandoc-build.sh /your/paper-dir/your-paper.md paper` will produce a properly referenced paper, from the markdown source, called `../build/paper/your-paper/your-paper.pdf`. 

## Creating Presentations

Providing all the dependencies have been satisfied, the script `bin/pandoc-build.sh /your/presentation-dir/your-presentation.md presentation` will produce a presentation, from the markdown source, called `../build/presentation/your-presentation/index.html`. You should also find the directory `../build/presentation/your-presentation/reveal.js`

### Running the Presentation

The easiest way is to load the file `build/presentation/bitcoin/index.html` into a Chrome browser.

However, if you want speaker notes, then you need to run the local reveal.js webserver. To do so:

+ Edit `../build/presentation/your-presentation/reveal.js/Gruntfile.js`, and rather than `var base = grunt.option('base') || '.';` set it to the following: `var base = grunt.option('base') || '../';`.
+ If this is the first time you have run the webserver from `../build/presentation/your-presentation/reveal.js`, then you will need to install required dependencies. Do so by running `npm install`.
+ Now run `grunt serve` from `../build/presentation/your-presentation/reveal.js`. The presentation should load into a browser window.
+ If you press the key `s`, you should see speaker notes running in a separate local browser tab. 
