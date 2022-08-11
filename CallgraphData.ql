import javascript

string prettyprintLocation(Location location) {
  exists(File file, int sl, int sc, int el, int ec |
    file = location.getFile() and
    location.hasLocationInfo(file.getAbsolutePath(), sl, sc, el, ec)
  |
    result = file.getRelativePath() + ":" + sl + ":" + sc + ":" + el + ":" + ec
  )
}

from DataFlow::Node invoke, Function f, string kind
where
  (
    invoke.(DataFlow::InvokeNode).getACallee() = f and kind = "Call"
    or
    invoke.(DataFlow::PropRef).getAnAccessorCallee().getFunction() = f and kind = "Accessor call"
  ) and
  not [invoke.getTopLevel(), f.getTopLevel()].isExterns()
select prettyprintLocation(invoke.asExpr().getLocation()) as callsite, kind,
  prettyprintLocation(f.getLocation()) as callee
