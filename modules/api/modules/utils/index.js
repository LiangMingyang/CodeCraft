/**
 * Created by lmy on 12/16/16.
 */
express = require('express');
router = express.Router({
    mergeParams: true
});


//var captcha = require('ccap')();
// router.get('/ccap', function(req, res) {
//     var ary = captcha.get();
//     req.session.captcha = ary[0];
//     res.end(ary[1]);
// });
exports.router = router;
