/* This file is part of Buggy.
 
 Buggy is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Buggy is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Buggy.  If not, see <http://www.gnu.org/licenses/>.
 */

define ["Buggy",
        "ls!src/server/symbol",
        "ls!src/server/implementation",
        "json!package","express", "body-parser"] (Buggy, Symbol, Implementation, pkg, express, body-parser) ->
    
  {
    serve: (data, options) ->
      app = express!
      
      app.use body-parser.urlencoded extended: true 
      app.use body-parser.json!
      
      app.use "/symbol", Symbol.router data
      app.use "/implementation", Implementation.router data
      app.get "/source-info", (req,res)->
        res.json {
          version: pkg.version
          buggy: Buggy.Buggy.version
        }
        
      app.listen options.port
  }
