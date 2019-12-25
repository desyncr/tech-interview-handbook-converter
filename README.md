# Tech-interview-handbook converter

This script converts the online [tech-interview-handbook](https://yangshun.github.io/tech-interview-handbook/) into a single-file self-contained html file to be exported as PDF or ePUB.

Warning: It doesn't contains the original styles and there are some conversion issues.

## How to run

    $ cd path-to-project/tech-interview-handbook
    $ git submodule init

    $ cd path-to-project
    $ bundle install
    $ thor book:build

The book should be created at output/book.html

## How does it work

It uses Thor gem to wrap the script and it uses YAML for various configuration (such as title, sections and so on, see: config/)

### Actions

- Loads config/config.yaml to determine various settings
- Loads config/content.yaml to determine the sections and articles
- Creates the title and TOC with the information from config/content.yaml
- Does some pre-parsing (search and replace) over the articles
- Uses github-markup gem to convert .md to .html

## Project structure

- assets/gh-md.css:
    - github-markdown styles (taken from https://github.com/sindresorhus/github-markdown-css)

- config/config.yml:
    - debug: Whether to output to $output or to stdout (easier to debug)
    - output: Path to save output to.
    - title: self-explanatory.
    - content:
        - toc: Where to find the YAML file describing the sections and articles, also used to build the TOC.
        - directory: Where to find the contents (tech-interview-handbook/contents)
        - extension: Content's file extension (.md)
    - presets:
        - css: CSS file to embeed.
        - head: <head> content, including title and styles.
        - body: Prefix and suffix for the body.
        - section: Same as above for each section.

- config/content.yaml:
    - title: Section title
    - blocks: Each article in the section
    - prefix: (optional) Prefix for each article (ie, if in a subdirectory under contents)

- output/: Where the final HTML file will be located.

- tech-interview-handbook: Should be the submodule for the repo.

- Gemfile, Gemfile.lock: Bundler deps

- README.md: This.

- book.thor: Thor's command.

## Feedback

If you'd like to contribute to the project or file a bug or feature request, please visit
[the project page][1].


## License

The project is licensed under the [GNU GPL v3][2] license.

  [1]: https://github.com/desyncr/tech-interview-handbook-converter/
  [2]: http://www.gnu.org/licenses/gpl.html

