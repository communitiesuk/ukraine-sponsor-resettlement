#!/bin/bash

RAILS_ENV=test rake db:prepare && rake db:migrate && rake
