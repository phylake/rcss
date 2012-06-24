# RubyCSS

## RubyCSS in 5 seconds

    # RubyCSS

    white = '#fff'
    _ ['a', 'span'] {
        color white
        _ ['.nested-class'] {
            color '#e0e0e0'
        }
    }

    # CSS produced

    a {
        color: #fff;
    }

    span {
        color: #fff;
    }
    
    a .nested-class {
        color: #e0e0e0;
    }
    
    span .nested-class {
        color: #e0e0e0;
    }

## What

An [internal dsl] [fowler] for css built on ruby

- Variables are ruby variables
- Mixins are ruby functions

## Why

- I like terse, expressive languages and wanted the full power of ruby behind my css
- I was sick of dealing with *other* frameworks' pseudo-language crap, environment assumptions, etc.

## How

### Variables

Variables are regular ruby variables meaning you can do things like

    # RubyCSS

    white = 0xffffff.color
    red = '#ff0000'
    r = 'ff'
    g = 'ee'
    b = 'dd'
    rgb_color = "##{r}#{g}#{b}"
    
    _ ['span', 'p'] {
        color white
        background_color rgb_color
        border_color red
    }

    # CSS produced

    span {
        color: #fff;
        background-color: #ffeedd;
        border-color: #ff0000;
    }

    p {
        color: #fff;
        background-color: #ffeedd;
        border-color: #ff0000;
    }

### Nesting

Nesting always begins with a `_`

    # RubyCSS
    _ ['span'] {
        color '#f8f8f8'
        _ ['.nested-class] {
            color '#fff'
        }
    }
    
    # CSS produced
    span {
        color: #f8f8f8;
    }
    
    span .nested-class {
        color: #fff;
    }

### Mixins

A mixin is a Ruby module nested under `RubyCss` containing any number of methods

    # A complete mixin that does nothing
    module RubyCss
        module YourCollectionOfMixins
            def your_mixin
                h = {}
                mixin h
            end

            def your_other_mixin
                mixin({})
            end
        end

        Dsl.send(:include, YourCollectionOfMixins)
    end

Each method must call `mixin` passing in a `Hash`

Here are 2 trivial mixins

    # your_mixins.rb
    require 'ruby_css'
    module RubyCss
        module SimpleMixinExample
            def drop_shadow(h, v, blur, color)
                m = {}
        
                ['', '-webkit-', '-moz'].each do |vendor|
                    m["#{vendor}box-shadow"] = "#{h}px #{v}px #{blur}px #{color}"
                end
                
                mixin m
            end
            
            def brighten(color, value)
                r = (((color >> 16) + value) & 0xff) << 16
                g = (((color >>  8) + value) & 0xff) <<  8
                b = (((color >>  0) + value) & 0xff) <<  0
                r | g | b
            end
        end
        
        Dsl.send(:include, SimpleMixinExample)
    end
    
    # input_file.whatever
    color = 0x333333
    _ ['div'] {
        drop_shadow(5, 10, 20, '#000')
        color( brighten(color, 10) )
    }
    
    # CSS produced
    div {
        box-shadow: 5px 10px 20px #000;
        -webkit-box-shadow: 5px 10px 20px #000;
        -moz-box-shadow: 5px 10px 20px #000;
        color: #3D3D3D;
    }

### Syntax details

#### Specifying colors

You can always specify a color a string `#fff`, `#e0e0e0`. This works well if you're not planning on doing any calculations with the color

If you are doing calculations you should specify the above as `0xffffff`, and `0xe0e0e0`. Then you can do any necessary calculations. Once calculations are complete you can call `.color` on the result.

    blue = 0x0000ff
    brighter_blue = brighten(blue, 1)
    color: brighter_blue.color

### Tips

#### Aliasing

If you want something a little less terse than `_` you can make a different method using aliasing

    module RubyCss
      class Dsl
        alias_method :something_less_terse, :_
      end
    end

and then use it in place of `_`

    something_less_terse ['a', 'span'] {
        color '#f8f8f8'
    }

#### A note about ruby hashes

I'm using ruby 1.9 which added an alternative syntax for declaring hashes. If this doesn't work for you

    def my_cool_mixin
        mixin({
            color: 0xe0e0d0
        })
    end
    
this will

    def my_cool_mixin
        mixin({
            :color => 0xe0e0d0
        })
    end

and is also the required syntax for using arrays as keys

    # USE THIS
    def my_cool_mixin
        mixin({
            ['.nested'] => '#e0e0d0'
        })
    end
    
    # NOT THIS
    def my_cool_mixin
        mixin({
            ['.nested']: '#e0e0d0'
        })
    end
    
    # OR THIS
    def my_cool_mixin
        mixin({
            :['.nested'] => '#e0e0d0'
        })
    end

### [Sass equivalents] [sass]

#### Variables

    blue = 0x3bbfce
    margin = '16px'
    _ ['content-navigation'] {
      border_color blue.color
      color( darken(blue, .09) )
    }

#### Nesting

    _ ['table.hl'] {
      margin 2em, 0
      _ ['td.ln'] {
        text_align 'right'
      }
    }
    
    _ ['li'] {
      font_family 'serif'
      font_weight 'bold'
      font_size '1.2em'
    }

#### Mixins

    require 'ruby_css'
    module RubyCss
        module SassMixinsExample

            def table_mixin
              the_mixin = {
                ['th'] => {
                  text_align: 'center',
                  font_weight: 'bold'
                },
                ['td', 'th'] => {
                  padding: '2px'
                }
              }
              mixin the_mixin
            end

            def left(dist)
              the_mixin = {
                float: 'left',
                margin_left: dist
              }
              mixin the_mixin
            end

        end
        
        Dsl.send(:include, SassMixinsExample)
    end

## Who

I built this for myself out of frustration with the alternatives. That said, I've tried to make it as accessible and intuitive as possible and would like to see it grow into a viable alternative to existing CSS frameworks.

### Dude, why isn't your CSS output optimized?

Because this tool has a specific focus, least of which is squeezing every byte out of the output. Also because I gzip my CSS and deploy it to a CDN which works just fine for my needs.

### Reasons **not** to use RubyCSS

- Core Ruby classes such as String and Fixnum are altered. If you need something that runs in Rails during the rest of the application this might not be the best option. While unlikely that the alterations will clash with Rails or other frameworks, I'm not ensuring compatibility with anything else.

- You need a language agnostic language: Sass, for example, stands on its own meaning other languages can write Sass parsers and you can take your Sass with you to another language's environment.

[fowler]: http://martinfowler.com/bliki/DomainSpecificLanguage.html
[sass]: http://sass-lang.com/
