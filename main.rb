#!/usr/bin/env ruby

lib_dir = File.expand_path(File.join(File.dirname(__FILE__), "lib"))
$: << lib_dir

require 'card_validator'

prog = CardValidator.new

prog.display_help
prog.console

