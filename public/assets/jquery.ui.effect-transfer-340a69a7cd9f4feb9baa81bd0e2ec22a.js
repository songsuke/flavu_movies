/*!
 * jQuery UI Effects 1.10.0
 * http://jqueryui.com
 *
 * Copyright 2013 jQuery Foundation and other contributors
 * Released under the MIT license.
 * http://jquery.org/license
 *
 * http://api.jqueryui.com/category/effects-core/
 */
jQuery.effects||function(t,e){var i="ui-effects-";t.effects={effect:{}},/*!
 * jQuery Color Animations v2.1.2
 * https://github.com/jquery/jquery-color
 *
 * Copyright 2013 jQuery Foundation and other contributors
 * Released under the MIT license.
 * http://jquery.org/license
 *
 * Date: Wed Jan 16 08:47:09 2013 -0600
 */
function(t,e){function i(t,e,i){var n=h[e.type]||{};return null==t?i||!e.def?null:e.def:(t=n.floor?~~t:parseFloat(t),isNaN(t)?e.def:n.mod?(t+n.mod)%n.mod:0>t?0:t>n.max?n.max:t)}function n(e){var i=u(),n=i._rgba=[];return e=e.toLowerCase(),p(l,function(t,s){var r,o=s.re.exec(e),a=o&&s.parse(o),l=s.space||"rgba";return a?(r=i[l](a),i[c[l].cache]=r[c[l].cache],n=i._rgba=r._rgba,!1):void 0}),n.length?("0,0,0,0"===n.join()&&t.extend(n,r.transparent),i):r[e]}function s(t,e,i){return i=(i+1)%1,1>6*i?t+6*(e-t)*i:1>2*i?e:2>3*i?t+6*(e-t)*(2/3-i):t}var r,o="backgroundColor borderBottomColor borderLeftColor borderRightColor borderTopColor color columnRuleColor outlineColor textDecorationColor textEmphasisColor",a=/^([\-+])=\s*(\d+\.?\d*)/,l=[{re:/rgba?\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*(?:,\s*(\d?(?:\.\d+)?)\s*)?\)/,parse:function(t){return[t[1],t[2],t[3],t[4]]}},{re:/rgba?\(\s*(\d+(?:\.\d+)?)\%\s*,\s*(\d+(?:\.\d+)?)\%\s*,\s*(\d+(?:\.\d+)?)\%\s*(?:,\s*(\d?(?:\.\d+)?)\s*)?\)/,parse:function(t){return[2.55*t[1],2.55*t[2],2.55*t[3],t[4]]}},{re:/#([a-f0-9]{2})([a-f0-9]{2})([a-f0-9]{2})/,parse:function(t){return[parseInt(t[1],16),parseInt(t[2],16),parseInt(t[3],16)]}},{re:/#([a-f0-9])([a-f0-9])([a-f0-9])/,parse:function(t){return[parseInt(t[1]+t[1],16),parseInt(t[2]+t[2],16),parseInt(t[3]+t[3],16)]}},{re:/hsla?\(\s*(\d+(?:\.\d+)?)\s*,\s*(\d+(?:\.\d+)?)\%\s*,\s*(\d+(?:\.\d+)?)\%\s*(?:,\s*(\d?(?:\.\d+)?)\s*)?\)/,space:"hsla",parse:function(t){return[t[1],t[2]/100,t[3]/100,t[4]]}}],u=t.Color=function(e,i,n,s){return new t.Color.fn.parse(e,i,n,s)},c={rgba:{props:{red:{idx:0,type:"byte"},green:{idx:1,type:"byte"},blue:{idx:2,type:"byte"}}},hsla:{props:{hue:{idx:0,type:"degrees"},saturation:{idx:1,type:"percent"},lightness:{idx:2,type:"percent"}}}},h={"byte":{floor:!0,max:255},percent:{max:1},degrees:{mod:360,floor:!0}},d=u.support={},f=t("<p>")[0],p=t.each;f.style.cssText="background-color:rgba(1,1,1,.5)",d.rgba=f.style.backgroundColor.indexOf("rgba")>-1,p(c,function(t,e){e.cache="_"+t,e.props.alpha={idx:3,type:"percent",def:1}}),u.fn=t.extend(u.prototype,{parse:function(s,o,a,l){if(s===e)return this._rgba=[null,null,null,null],this;(s.jquery||s.nodeType)&&(s=t(s).css(o),o=e);var h=this,d=t.type(s),f=this._rgba=[];return o!==e&&(s=[s,o,a,l],d="array"),"string"===d?this.parse(n(s)||r._default):"array"===d?(p(c.rgba.props,function(t,e){f[e.idx]=i(s[e.idx],e)}),this):"object"===d?(s instanceof u?p(c,function(t,e){s[e.cache]&&(h[e.cache]=s[e.cache].slice())}):p(c,function(e,n){var r=n.cache;p(n.props,function(t,e){if(!h[r]&&n.to){if("alpha"===t||null==s[t])return;h[r]=n.to(h._rgba)}h[r][e.idx]=i(s[t],e,!0)}),h[r]&&0>t.inArray(null,h[r].slice(0,3))&&(h[r][3]=1,n.from&&(h._rgba=n.from(h[r])))}),this):void 0},is:function(t){var e=u(t),i=!0,n=this;return p(c,function(t,s){var r,o=e[s.cache];return o&&(r=n[s.cache]||s.to&&s.to(n._rgba)||[],p(s.props,function(t,e){return null!=o[e.idx]?i=o[e.idx]===r[e.idx]:void 0})),i}),i},_space:function(){var t=[],e=this;return p(c,function(i,n){e[n.cache]&&t.push(i)}),t.pop()},transition:function(t,e){var n=u(t),s=n._space(),r=c[s],o=0===this.alpha()?u("transparent"):this,a=o[r.cache]||r.to(o._rgba),l=a.slice();return n=n[r.cache],p(r.props,function(t,s){var r=s.idx,o=a[r],u=n[r],c=h[s.type]||{};null!==u&&(null===o?l[r]=u:(c.mod&&(u-o>c.mod/2?o+=c.mod:o-u>c.mod/2&&(o-=c.mod)),l[r]=i((u-o)*e+o,s)))}),this[s](l)},blend:function(e){if(1===this._rgba[3])return this;var i=this._rgba.slice(),n=i.pop(),s=u(e)._rgba;return u(t.map(i,function(t,e){return(1-n)*s[e]+n*t}))},toRgbaString:function(){var e="rgba(",i=t.map(this._rgba,function(t,e){return null==t?e>2?1:0:t});return 1===i[3]&&(i.pop(),e="rgb("),e+i.join()+")"},toHslaString:function(){var e="hsla(",i=t.map(this.hsla(),function(t,e){return null==t&&(t=e>2?1:0),e&&3>e&&(t=Math.round(100*t)+"%"),t});return 1===i[3]&&(i.pop(),e="hsl("),e+i.join()+")"},toHexString:function(e){var i=this._rgba.slice(),n=i.pop();return e&&i.push(~~(255*n)),"#"+t.map(i,function(t){return t=(t||0).toString(16),1===t.length?"0"+t:t}).join("")},toString:function(){return 0===this._rgba[3]?"transparent":this.toRgbaString()}}),u.fn.parse.prototype=u.fn,c.hsla.to=function(t){if(null==t[0]||null==t[1]||null==t[2])return[null,null,null,t[3]];var e,i,n=t[0]/255,s=t[1]/255,r=t[2]/255,o=t[3],a=Math.max(n,s,r),l=Math.min(n,s,r),u=a-l,c=a+l,h=.5*c;return e=l===a?0:n===a?60*(s-r)/u+360:s===a?60*(r-n)/u+120:60*(n-s)/u+240,i=0===u?0:.5>=h?u/c:u/(2-c),[Math.round(e)%360,i,h,null==o?1:o]},c.hsla.from=function(t){if(null==t[0]||null==t[1]||null==t[2])return[null,null,null,t[3]];var e=t[0]/360,i=t[1],n=t[2],r=t[3],o=.5>=n?n*(1+i):n+i-n*i,a=2*n-o;return[Math.round(255*s(a,o,e+1/3)),Math.round(255*s(a,o,e)),Math.round(255*s(a,o,e-1/3)),r]},p(c,function(n,s){var r=s.props,o=s.cache,l=s.to,c=s.from;u.fn[n]=function(n){if(l&&!this[o]&&(this[o]=l(this._rgba)),n===e)return this[o].slice();var s,a=t.type(n),h="array"===a||"object"===a?n:arguments,d=this[o].slice();return p(r,function(t,e){var n=h["object"===a?t:e.idx];null==n&&(n=d[e.idx]),d[e.idx]=i(n,e)}),c?(s=u(c(d)),s[o]=d,s):u(d)},p(r,function(e,i){u.fn[e]||(u.fn[e]=function(s){var r,o=t.type(s),l="alpha"===e?this._hsla?"hsla":"rgba":n,u=this[l](),c=u[i.idx];return"undefined"===o?c:("function"===o&&(s=s.call(this,c),o=t.type(s)),null==s&&i.empty?this:("string"===o&&(r=a.exec(s),r&&(s=c+parseFloat(r[2])*("+"===r[1]?1:-1))),u[i.idx]=s,this[l](u)))})})}),u.hook=function(e){var i=e.split(" ");p(i,function(e,i){t.cssHooks[i]={set:function(e,s){var r,o,a="";if("transparent"!==s&&("string"!==t.type(s)||(r=n(s)))){if(s=u(r||s),!d.rgba&&1!==s._rgba[3]){for(o="backgroundColor"===i?e.parentNode:e;(""===a||"transparent"===a)&&o&&o.style;)try{a=t.css(o,"backgroundColor"),o=o.parentNode}catch(l){}s=s.blend(a&&"transparent"!==a?a:"_default")}s=s.toRgbaString()}try{e.style[i]=s}catch(l){}}},t.fx.step[i]=function(e){e.colorInit||(e.start=u(e.elem,i),e.end=u(e.end),e.colorInit=!0),t.cssHooks[i].set(e.elem,e.start.transition(e.end,e.pos))}})},u.hook(o),t.cssHooks.borderColor={expand:function(t){var e={};return p(["Top","Right","Bottom","Left"],function(i,n){e["border"+n+"Color"]=t}),e}},r=t.Color.names={aqua:"#00ffff",black:"#000000",blue:"#0000ff",fuchsia:"#ff00ff",gray:"#808080",green:"#008000",lime:"#00ff00",maroon:"#800000",navy:"#000080",olive:"#808000",purple:"#800080",red:"#ff0000",silver:"#c0c0c0",teal:"#008080",white:"#ffffff",yellow:"#ffff00",transparent:[null,null,null,0],_default:"#ffffff"}}(jQuery),function(){function i(e){var i,n,s=e.ownerDocument.defaultView?e.ownerDocument.defaultView.getComputedStyle(e,null):e.currentStyle,r={};if(s&&s.length&&s[0]&&s[s[0]])for(n=s.length;n--;)i=s[n],"string"==typeof s[i]&&(r[t.camelCase(i)]=s[i]);else for(i in s)"string"==typeof s[i]&&(r[i]=s[i]);return r}function n(e,i){var n,s,o={};for(n in i)s=i[n],e[n]!==s&&(r[n]||(t.fx.step[n]||!isNaN(parseFloat(s)))&&(o[n]=s));return o}var s=["add","remove","toggle"],r={border:1,borderBottom:1,borderColor:1,borderLeft:1,borderRight:1,borderTop:1,borderWidth:1,margin:1,padding:1};t.each(["borderLeftStyle","borderRightStyle","borderBottomStyle","borderTopStyle"],function(e,i){t.fx.step[i]=function(t){("none"!==t.end&&!t.setAttr||1===t.pos&&!t.setAttr)&&(jQuery.style(t.elem,i,t.end),t.setAttr=!0)}}),t.fn.addBack||(t.fn.addBack=function(t){return this.add(null==t?this.prevObject:this.prevObject.filter(t))}),t.effects.animateClass=function(e,r,o,a){var l=t.speed(r,o,a);return this.queue(function(){var r,o=t(this),a=o.attr("class")||"",u=l.children?o.find("*").addBack():o;u=u.map(function(){var e=t(this);return{el:e,start:i(this)}}),r=function(){t.each(s,function(t,i){e[i]&&o[i+"Class"](e[i])})},r(),u=u.map(function(){return this.end=i(this.el[0]),this.diff=n(this.start,this.end),this}),o.attr("class",a),u=u.map(function(){var e=this,i=t.Deferred(),n=t.extend({},l,{queue:!1,complete:function(){i.resolve(e)}});return this.el.animate(this.diff,n),i.promise()}),t.when.apply(t,u.get()).done(function(){r(),t.each(arguments,function(){var e=this.el;t.each(this.diff,function(t){e.css(t,"")})}),l.complete.call(o[0])})})},t.fn.extend({_addClass:t.fn.addClass,addClass:function(e,i,n,s){return i?t.effects.animateClass.call(this,{add:e},i,n,s):this._addClass(e)},_removeClass:t.fn.removeClass,removeClass:function(e,i,n,s){return i?t.effects.animateClass.call(this,{remove:e},i,n,s):this._removeClass(e)},_toggleClass:t.fn.toggleClass,toggleClass:function(i,n,s,r,o){return"boolean"==typeof n||n===e?s?t.effects.animateClass.call(this,n?{add:i}:{remove:i},s,r,o):this._toggleClass(i,n):t.effects.animateClass.call(this,{toggle:i},n,s,r)},switchClass:function(e,i,n,s,r){return t.effects.animateClass.call(this,{add:i,remove:e},n,s,r)}})}(),function(){function n(e,i,n,s){return t.isPlainObject(e)&&(i=e,e=e.effect),e={effect:e},null==i&&(i={}),t.isFunction(i)&&(s=i,n=null,i={}),("number"==typeof i||t.fx.speeds[i])&&(s=n,n=i,i={}),t.isFunction(n)&&(s=n,n=null),i&&t.extend(e,i),n=n||i.duration,e.duration=t.fx.off?0:"number"==typeof n?n:n in t.fx.speeds?t.fx.speeds[n]:t.fx.speeds._default,e.complete=s||i.complete,e}function s(e){return!e||"number"==typeof e||t.fx.speeds[e]?!0:"string"==typeof e&&!t.effects.effect[e]}t.extend(t.effects,{version:"1.10.0",save:function(t,e){for(var n=0;e.length>n;n++)null!==e[n]&&t.data(i+e[n],t[0].style[e[n]])},restore:function(t,n){var s,r;for(r=0;n.length>r;r++)null!==n[r]&&(s=t.data(i+n[r]),s===e&&(s=""),t.css(n[r],s))},setMode:function(t,e){return"toggle"===e&&(e=t.is(":hidden")?"show":"hide"),e},getBaseline:function(t,e){var i,n;switch(t[0]){case"top":i=0;break;case"middle":i=.5;break;case"bottom":i=1;break;default:i=t[0]/e.height}switch(t[1]){case"left":n=0;break;case"center":n=.5;break;case"right":n=1;break;default:n=t[1]/e.width}return{x:n,y:i}},createWrapper:function(e){if(e.parent().is(".ui-effects-wrapper"))return e.parent();var i={width:e.outerWidth(!0),height:e.outerHeight(!0),"float":e.css("float")},n=t("<div></div>").addClass("ui-effects-wrapper").css({fontSize:"100%",background:"transparent",border:"none",margin:0,padding:0}),s={width:e.width(),height:e.height()},r=document.activeElement;try{r.id}catch(o){r=document.body}return e.wrap(n),(e[0]===r||t.contains(e[0],r))&&t(r).focus(),n=e.parent(),"static"===e.css("position")?(n.css({position:"relative"}),e.css({position:"relative"})):(t.extend(i,{position:e.css("position"),zIndex:e.css("z-index")}),t.each(["top","left","bottom","right"],function(t,n){i[n]=e.css(n),isNaN(parseInt(i[n],10))&&(i[n]="auto")}),e.css({position:"relative",top:0,left:0,right:"auto",bottom:"auto"})),e.css(s),n.css(i).show()},removeWrapper:function(e){var i=document.activeElement;return e.parent().is(".ui-effects-wrapper")&&(e.parent().replaceWith(e),(e[0]===i||t.contains(e[0],i))&&t(i).focus()),e},setTransition:function(e,i,n,s){return s=s||{},t.each(i,function(t,i){var r=e.cssUnit(i);r[0]>0&&(s[i]=r[0]*n+r[1])}),s}}),t.fn.extend({effect:function(){function e(e){function n(){t.isFunction(r)&&r.call(s[0]),t.isFunction(e)&&e()}var s=t(this),r=i.complete,a=i.mode;(s.is(":hidden")?"hide"===a:"show"===a)?n():o.call(s[0],i,n)}var i=n.apply(this,arguments),s=i.mode,r=i.queue,o=t.effects.effect[i.effect];return t.fx.off||!o?s?this[s](i.duration,i.complete):this.each(function(){i.complete&&i.complete.call(this)}):r===!1?this.each(e):this.queue(r||"fx",e)},_show:t.fn.show,show:function(t){if(s(t))return this._show.apply(this,arguments);var e=n.apply(this,arguments);return e.mode="show",this.effect.call(this,e)},_hide:t.fn.hide,hide:function(t){if(s(t))return this._hide.apply(this,arguments);var e=n.apply(this,arguments);return e.mode="hide",this.effect.call(this,e)},__toggle:t.fn.toggle,toggle:function(e){if(s(e)||"boolean"==typeof e||t.isFunction(e))return this.__toggle.apply(this,arguments);var i=n.apply(this,arguments);return i.mode="toggle",this.effect.call(this,i)},cssUnit:function(e){var i=this.css(e),n=[];return t.each(["em","px","%","pt"],function(t,e){i.indexOf(e)>0&&(n=[parseFloat(i),e])}),n}})}(),function(){var e={};t.each(["Quad","Cubic","Quart","Quint","Expo"],function(t,i){e[i]=function(e){return Math.pow(e,t+2)}}),t.extend(e,{Sine:function(t){return 1-Math.cos(t*Math.PI/2)},Circ:function(t){return 1-Math.sqrt(1-t*t)},Elastic:function(t){return 0===t||1===t?t:-Math.pow(2,8*(t-1))*Math.sin((80*(t-1)-7.5)*Math.PI/15)},Back:function(t){return t*t*(3*t-2)},Bounce:function(t){for(var e,i=4;((e=Math.pow(2,--i))-1)/11>t;);return 1/Math.pow(4,3-i)-7.5625*Math.pow((3*e-2)/22-t,2)}}),t.each(e,function(e,i){t.easing["easeIn"+e]=i,t.easing["easeOut"+e]=function(t){return 1-i(1-t)},t.easing["easeInOut"+e]=function(t){return.5>t?i(2*t)/2:1-i(-2*t+2)/2}})}()}(jQuery),/*!
 * jQuery UI Effects Transfer 1.10.0
 * http://jqueryui.com
 *
 * Copyright 2013 jQuery Foundation and other contributors
 * Released under the MIT license.
 * http://jquery.org/license
 *
 * http://api.jqueryui.com/transfer-effect/
 *
 * Depends:
 *	jquery.ui.effect.js
 */
function(t){t.effects.effect.transfer=function(e,i){var n=t(this),s=t(e.to),r="fixed"===s.css("position"),o=t("body"),a=r?o.scrollTop():0,l=r?o.scrollLeft():0,u=s.offset(),c={top:u.top-a,left:u.left-l,height:s.innerHeight(),width:s.innerWidth()},h=n.offset(),d=t("<div class='ui-effects-transfer'></div>").appendTo(document.body).addClass(e.className).css({top:h.top-a,left:h.left-l,height:n.innerHeight(),width:n.innerWidth(),position:r?"fixed":"absolute"}).animate(c,e.duration,e.easing,function(){d.remove(),i()})}}(jQuery);