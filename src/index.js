import _ from 'lodash';


// src/application.js
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("./controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

import { Clipboard } from "stimulus-form-utilities"
application.register('clipboard', Clipboard)
