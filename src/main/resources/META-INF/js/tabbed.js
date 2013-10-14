var MAX_VALUE_SHOW_SIZE = 40,
      MAX_URL_SHOW_SIZE = 30;
      

function getElementsByClassName(strClassName, obj) {
    var classElements = arguments[2] || [],
	regExp = new RegExp("\\b" + strClassName + "\\b", "g");

    if (regExp.test(obj.className)) {
        classElements.push(obj);
    }
    for (var i = 0, max = obj.childNodes.length; i < max; i++)
        getElementsByClassName(strClassName, obj.childNodes[i], classElements);
    
    return classElements;
}


function substituteContentByClass(className,originalContent,newContent){
    var classElements = getElementsByClassName(className, document.body);
    for (var i = 0, max = classElements.length; i < max; i++) {
      if(classElements[i].textContent==originalContent) {
	 classElements[i].innerHTML=newContent;
      }
    }
}

//accordion - start
var s = 7000;
var t = 0;
   
function dsp(d, v) {
    if (!v) {
	return d.style.display;
    } else {
	d.style.display = v;
    }
}

// set or get the height of a div.

function sh(d, v) {
    var viz, o, r, factor_r;
    // if you are getting the height then display must be block to return the absolute height
    if (!v) {
	if (dsp(d) != 'none' && dsp(d) != '') {
	    return d.offsetHeight;
	}
	viz = d.style.visibility;
	d.style.visibility = 'hidden';
	o = dsp(d);
	dsp(d, 'block');
	r = parseInt(d.offsetHeight);
	dsp(d, o);
	d.style.visibility = viz;
	factor_r = 1.25;
	if (navigator.userAgent.toLowerCase().indexOf("firefox") != -1) 
	    factor_r = 1.22;
	return r*factor_r;
    } else {
	d.style.height = v;
	d.style.overflowY = "visible";
    }
}

//Collapse Timer is triggered as a setInterval to reduce the height of the div exponentially.

function ct(d) {
   d = document.getElementById(d);
   sh(d, 0);
   dsp(d, 'none');
   clearInterval(d.t);
}

//Expand Timer is triggered as a setInterval to increase the height of the div exponentially.

function et(d) {
    var v;
    d = document.getElementById(d);
    if (sh(d) < d.maxh) {
	v = Math.round((d.maxh - sh(d)) / d.s);
	v = (v < 1) ? 1 : v;
	v = sh(d) + v;
	sh(d, v + 'px');
	d.style.opacity = (v / d.maxh);
	d.style.filter= 'alpha(opacity='+(v*100 / d.maxh) + ');';
    } else {
	sh(d, d.maxh);
	clearInterval(d.t);
    }
}

// Collapse Initializer

function cl(d) {
    if (dsp(d) == 'block') {
	clearInterval(d.t);
	d.t = setInterval('ct("' + d.id + '")', t);
    }
}

//Expand Initializer

function ex(d) {
    if (dsp(d) == 'none') {
	dsp(d, 'block');
	d.style.height='0px';
	clearInterval(d.t);
	d.t = setInterval('et("' + d.id + '")', t);
    }
}

// Removes Classname from the given div.

function cc(n, v){
    s = n.className.split(/\s+/);
    for (var p = 0, max = s.length;p < max;p++) {
	if (s[p] == v + n.tc) {
	    s.splice(p, 1);
	    n.className=s.join(' ');
	    break;
	}
    }
}

//Accordian Initializer

function Accordian(d, s, tc) {
    // get all the elements that have id as content
    var l = document.getElementById(d).getElementsByTagName('div'),
	c = [],
	sel = null,
	h, cn, n;
    for (var i = 0, max = l.length;i < max;i++) {
	var h = l[i].id;
	if (h.substr(h.indexOf('-') + 1,h.length) == 'content') {c.push(h);}
    }
    //then search through headers
    for (var i = 0, max = l.length;i < max;i++) {
	h = l[i].id;
	if (h.substr(h.indexOf('-') + 1, h.length) == 'header') {
	    d=document.getElementById(h.substr(0, h.indexOf('-'))+'-content');
	    d.style.display = 'none';
	    d.style.overflow = 'hidden';
	    d.maxh = sh(d);
	    d.s = (s==undefined)? 7 : s;
	    h = document.getElementById(h);
	    h.tc = tc;
	    h.c = c;
	    // set the onclick function for each header.
	    h.onclick = function() {
		for (var i = 0, max = c.length;i < max;i++) {
		    cn = this.c[i];
		    n = cn.substr(0,cn.indexOf('-'));
		    if ((n + '-header') == this.id) {
			ex(document.getElementById(n + '-content'));
			n = document.getElementById(n + '-header');
			cc(n,'__');
			n.className=n.className+' '+n.tc;
		    } else {
			cl(document.getElementById(n + '-content'));
			cc(document.getElementById(n + '-header'),'');
		    }
		}
	    }
	    if (sel == undefined){ sel=h;}
	}
    }
    if (sel != undefined){sel.onclick();}
}
//accordion - end
   
function initAcc() {
      if (formMode == "create") {
            try{
                  document.getElementById("${id}-dialog_c").style.width = "90%";
                  document.getElementById("${id}-dialog").style.width = "100%";
                  document.getElementById("${id}-dialog").style.height = "100%";
            } catch (e) {}
      } 
      
      new Accordian('basic-accordian', 5, 'header_highlight');
      
      return false;
}

