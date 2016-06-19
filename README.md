# pandoc-build.sh

This is home to a small script, [pandoc-build.sh](bin/pandoc-build.sh), which can build [properly referenced pdfs](https://github.com/glowkeeper/Markdown-with-References) and/or presentations from source [Markdown](https://daringfireball.net/projects/markdown/). 

To use [pandoc-build.sh](bin/pandoc-build.sh), clone this repository onto a Mac (it probably works on 'nix's too, but I've not verified that) and follow the instructions below.

## Disclaimer

[pandoc-build.sh](bin/pandoc-build.sh) is provided as-is. It is not military grade and if it works out of the box, well, that's remarkable :) However, I hope it serves as a good example of the use of [pandoc](https://github.com/jgm/pandoc/releases/download/1.17.0.2/).

## Dependencies

Ensure the following dependencies are met.

### General Dependencies

You'll need the following software:

+ [pandoc](https://github.com/jgm/pandoc/releases/download/1.17.0.2/pandoc-1.17.0.2-osx.pkg "pandoc")
+ A LaTex processor. The [BasicTex](http://tug.org/cgi-bin/mactex-download/BasicTeX.pkg "BasicTex") package will suffice

### Paper Dependencies

The paper relies on BibTex references. Hence, you'll need:

+ A reference manager that can output [BibTeX](http://www.bibtex.org/). I use [Zotero](https://www.zotero.org/), which works best with [Firefox](https://www.mozilla.org/en-GB/firefox/new/) and [Firefox's Zotero plugin](https://download.zotero.org/extension/zotero-4.0.29.10.xpi). Additionally, I use Zotero's [Better BibText](https://github.com/retorquere/zotero-better-bibtex) plugin, primarily because that helps avoid citation key clashes. The BibTex should be exported to `/your/paper-dir/bibliography/library.bib`
+ A [Citation Style Language](http://citationstyles.org/) (CSL) file that matches the citation style you need. The [Zotero Style Repository](https://www.zotero.org/styles) has many such files. I often have to produce IEEE citations, for which I use the file [IEEE with URL](https://www.zotero.org/styles/ieee-with-url). The CSL file should be saved to `/your/paper-dir/bibliography/ieee-with-url.csl`
+ Create the meta file `/your/paper-dir/meta.txt`, which contains your paper's title, the author(s), the header and the footer. Here's an example _meta.txt_:

        ---<br>
        title: Paper Title<br>
        author: Your Name<br>
        header-includes:<br>
            - \usepackage{fancyhdr}<br>
            - \pagestyle{fancy}<br>
            - \lhead{\thepage}<br>
            - \chead{}<br>
            - \rhead{}<br>
            - \lfoot{© Your Name}<br>
            - \cfoot{}<br>
            - \rfoot{}<br>
            - \renewcommand{\headrulewidth}{0.4pt}<br>
            - \renewcommand{\footrulewidth}{0.4pt}<br>
        ---<br>

### Presentation Dependencies

You'll need:

+ [reveal.js](https://github.com/hakimel/reveal.js/)
+ A CSS file for styling your presentation. e.g:

    	<style type="text/css">
    	  .reveal .slides { margin-top: 40px; }
    	  .reveal .slides li { font-size: 1.1em; }
    	  .reveal p { font-size: 1.1em; }
    	</style>

### Modify your PATH Variable

The pandoc and LaTex must be in your your `$PATH`; e.g `export PATH=$PATH:/usr/local/bin:/usr/texbin`.

## Creating PDF's

The following are instructions for creating properly referenced papers.

### Formating Your Markdown

[This is a link to example Markdown](https://daringfireball.net/projects/markdown/).

### References

References should be of the form `@bibtex_citation_key`, e.g:

_Here's the terrifying truth: there are already enough known fossil fuel reserves to fry Planet Earth five times over @bill_mckibben_global_2012._

### Images

Images should be refenced this way: `![Image](images/image.jpg "Image")`

### Outputting the Paper

Providing all the dependencies have been satisfied, then calling the script this way: `bin/pandoc-build.sh /your/paper-dir/your-paper.md paper`, should produce a properly referenced paper, from the markdown source, called `../build/paper/your-paper/your-paper.pdf`. 

## Creating Presentations

The following are instructions for creating presentations.

### Formating Your Markdown

[This is a link to example Markdown](https://daringfireball.net/projects/markdown/). Below is an example that you could copy and paste and then work out what it does (you will need to copy an image to `/your/presentation-dir/images/an_image.png`):

    # Title

    by You

    ![](images/an_image.png)

    _Source: a reference_

    - - -

    # Section 1

    ![](images/an_image.png)

    _Source: a reference_

    - - -

    ## Section 1.1

    > + Text point 1
    > + Text point 2
    > + Text point 3

    ## Section 1.2

    _"Any tool should be useful in the expected way, but a truly great tool lends itself to uses you never expected."_

    _Eric S. Raymond: The Cathedral and the Bazaar_

    # Section 2

    ![](images/an_image.png)

    _Source: a reference_

    - - -

    ## Section 2.1

    Some text

    . . .

    Some more text.

    . . .

    Yet more text.

    ## Section 2.2

    An ordinary numbered list:

    1. Point 1
    2. Point 2
    3. Point 3

    # Section 3

    ![](images/an_image.png)

    _Source: a reference_

    - - -

    # Thank You

### Images

Images should be refenced this way: `![](images/image.png)`

### Outputting the Presentation

Providing all the dependencies have been satisfied, then calling the script this way: `bin/pandoc-build.sh /your/presentation-dir/your-presentation.md presentation`, should produce a presentation, from the markdown source, called `../build/presentation/your-presentation/index.html`. You should also find the directory `../build/presentation/your-presentation/reveal.js`

### Running the Presentation

The easiest way is to load the file `build/presentation/your-presentation/index.html` into a Chrome browser.

However, if you want speaker notes, then you need to run the local reveal.js webserver. To do so:

+ Edit `../build/presentation/your-presentation/reveal.js/Gruntfile.js`, and rather than `var base = grunt.option('base') || '.';` set it to the following: `var base = grunt.option('base') || '../';`.
+ If this is the first time you have run the webserver from `../build/presentation/your-presentation/reveal.js`, then you will need to install required dependencies. Do so by running `npm install`.
+ Now run `grunt serve` from `../build/presentation/your-presentation/reveal.js`. The presentation should load into a browser window.
+ If you press the key `s`, you should see speaker notes running in a separate local browser tab. 
