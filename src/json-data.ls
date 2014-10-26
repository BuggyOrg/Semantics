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

define ["Buggy","fs"], (Buggy, fs) ->
  Buggy = Buggy.Buggy
  {
    load: (file) ->
      if !fs.existsSync file
        fs.writeFileSync file, JSON.stringify Buggy.Semantics.create-semantics!
      data = JSON.parse fs.readFileSync file
      data.base-file = file
      return data
    
    store: (data) ->
      fs.writeFile data.base-file, JSON.stringify data
  }
