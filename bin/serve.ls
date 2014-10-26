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

global <<< require \prelude-ls
require "./rjs-conf.js"
server = requirejs "ls!src/server/server"
json-data = requirejs "ls!src/json-data"

data = json-data.load process.argv.2

port = process.env.PORT or 6789;
server.serve data, {port: port}

console.log "Buggy semantics listening on port #port"
