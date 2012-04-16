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

    a, span {
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
- I was sick of dealing with *other* frameworks' pseudo-language crap, rails integration issues, etc.

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

    span, p {
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

Here's 2 trivial mixins

    # your_mixins.rb
    require 'ruby_css'
    module RubyCss
        module SimpleMixinExample
            def drop_shadow(h, v, blur, color, inset=false)
                m = {}
        
                ['', '-webkit-', '-moz'].each do |v|
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
        color( brighten(color, 1) )
    }
    
    # CSS produced
    div {
        box-shadow: 5px 10px 20px #000;
        -webkit-box-shadow: 5px 10px 20px #000;
        -moz-box-shadow: 5px 10px 20px #000;
        color: #3D3D3D;
    }

### Syntax details

TODO fill this in

### Tips

#### Aliasing

If you want something a little less terse than the `_` you can make a different method using aliasing

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
        h = {
            color: 0xe0e0d0
        }
        mixin h
    end
    
this will

    def my_cool_mixin
        h = {
            :color => 0xe0e0d0
        }
        mixin h
    end

and is also the required syntax for using arrays as keys

    # USE THIS
    def my_cool_mixin
        h = {
            ['.nested'] => '#e0e0d0'
        }
        mixin h
    end
    
    # NOT THIS
    def my_cool_mixin
        h = {
            ['.nested']: '#e0e0d0'
        }
        mixin h
    end
    
    # OR THIS
    def my_cool_mixin
        h = {
            :['.nested'] => '#e0e0d0'
        }
        mixin h
    end

### [Sass equivalents] [sass]

#### Variables

    blue = '#3bbfce'
    margin = '16px'
    _ ['content-navigation'] {
      border_color blue
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
                th: {
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

I built this for myself because I have shit to do. I imagine it will be useful for other developers who share that sentiment. That said, I've tried to make it as accessible and intuitive as possible and would like to see it grow into a viable alternative to existing CSS frameworks.

[fowler]: http://martinfowler.com/bliki/DomainSpecificLanguage.html
[sass]: http://sass-lang.com/
