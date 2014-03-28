
# GET index (/) page.
exports.index = (req, res) ->
  res.render "index",
    title: "Facebook Login"