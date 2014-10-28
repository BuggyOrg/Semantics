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
  Implementation = Buggy.Implementation
  
  req-cuid = (req,res) ->
    if !req.body.cuid?
      res.json status: "error" msg: "cuid is required"
      return false
    return true
  
  {
    router: (data) ->
      router = express.Router!
      router.get "/by-name/:name", (req, res) -> 
        res.json (data.implementations |> filter -> it.name == req.params.name)
      router.get "/search-by-name/:name", (req,res)->
        res.json (data.implementations |> filter -> (it.name.indexOf req.params.name) > -1)
      router.get "/by-cuid/:cuid", (req, res) -> 
        res.json (data.implementations |> filter -> it.cuid == req.params.cuid)
      router.get "/all", (req,res) ->
        res.json data.implementations
      router.post "/", (req,res) ->
        implementation = Implementation.create req.body
        implementation.cuid = cuid!
        data.implementations.push implementation
        dt.store data
        res.json status: "ok" implementation: implementation
      router.put "/", (req, res) ->
        if !req-cuid req,res then return
        new-implementation = Implementation.create req.body
        data.implementations = (data.implementations |> map ->
          if it.cuid == new-implementation.cuid
            Implementation.create new-implementation
          else
            it)
        dt.store data
        res.json status: "ok" implementation: new-implementation
      router.delete "/", (req,res) ->
        if !req-cuid req,res then return
        impl-before = data.implementations.length
        data.implementations := (data.implementations |> reject -> it.cuid == req.body.cuid)
        dt.store data
        res.json status: "ok" deleted: (impl-before - data.implementations.length)
  }
