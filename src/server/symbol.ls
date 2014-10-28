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

define ["Buggy","ls!src/json-data", "express", "cuid"] (Buggy, dt, express, cuid) ->
  Buggy = Buggy.Buggy
  Symbol = Buggy.Symbol
  
  req-cuid = (req,res) ->
    if !req.body.cuid?
      res.json status: "error" msg: "cuid is required"
      return false
    return true
  
  {
    router: (data) ->
      router = express.Router!
      router.get "/by-name/:name", (req, res) -> 
        res.json (data.symbols |> filter -> it.name == req.params.name)
      router.get "/search-by-name/:name", (req,res)->
        res.json (data.symbols |> filter -> (it.name.indexOf req.params.name) > -1)
      router.get "/by-cuid/:cuid", (req, res) -> 
        res.json (data.symbols |> filter -> it.cuid == req.params.cuid)
      router.get "/all", (req,res) ->
        res.json data.symbols
      router.post "/", (req,res) ->
        symbol = Symbol.create req.body
        symbol.cuid = cuid!
        data.symbols.push symbol
        dt.store data
        res.json status: "ok" symbol: symbol
      router.put "/", (req, res) ->
        if !req-cuid req,res then return
        new-symbol = Symbol.create req.body
        data.symbols = (data.symbols |> map ->
          if it.cuid == new-symbol.cuid
            Symbol.create new-symbol
          else
            it)
        dt.store data
        res.json status: "ok" symbol: new-symbol
      router.delete "/", (req,res) ->
        if !req-cuid req,res then return
        sym-before = data.symbols.length
        data.symbols := (data.symbols |> reject -> it.cuid == req.body.cuid)
        dt.store data
        res.json status: "ok" deleted: (sym-before - data.symbols.length)
  }
