# Stabilität von Differentialgleichunssystemen mit Javascript und JSXGraph
(2014-10-02, im Moment etwas beschädigt)
Hier ein weiteres Beispiel aus besagter Vorlesung.

<!-- more -->

Es geht
um die Stabilität des  Punktes $\begin{pmatrix}0\\0\end{pmatrix}$ im
Differentialgleichungssystem

$$
\dot x_1 = a_{11} x_1 + a_{12} x_2\\
\dot x_2 = a_{21} x_1 + a_{22} x_2.
$$

Bedienung:

- Bitte in der Tabelle das Stabilitätsbeispiel auswählen
- In der rechten Graphik kann der grüne Punkt verschoben werden
- Die Schieber  in der linken Graphik erlauben die Modifikation
  des Modells


~~~
<style type="text/css">
.jxgbox {
    position:relative; /* for IE 7 */
    overflow:hidden;
    background-color:#ffffff;
    border-style:solid;
    border-width:1px;
    border-color:#356AA0;
    -moz-border-radius:10px;
    -webkit-border-radius:10px;
}

.JXGtext {
    background-color: transparent; /* May produce artefacts in IE. Solution: setting a color explicitly. */
    font-family: Arial, Helvetica, Geneva;
    padding: 0px;
    margin: 0px;
    /*line-height:100%;*/ /* This has to be commented out. Otherwise subscripts are not visible in IE */
    /*border-style:dotted;*/
    /*border-width:0.4px;*/
}

.navbar { color: #aaaaaa; background-color: #f5f5f5; padding: 2px;
position: absolute; font-size: 10px; cursor: pointer; z-index: 100;
right: 5px; bottom: 5px; } 
</style>
<script type="text/javascript"  src="http://cdnjs.cloudflare.com/ajax/libs/jsxgraph/0.92/jsxgraphcore.js"></script>
<font size=-2>
   <table style='border-width:1px; border-style: solid;'>
<tr style='border-width:1px; border-style: solid;'> 
   <td style='border-width:1px; border-style: solid;'> $\lambda_1,\lambda_2>0$</td>
   <td style='border-width:1px; border-style: solid;'> $\lambda_1,\lambda_2<0$</td>
   <td style='border-width:1px; border-style: solid;'> $\lambda_1>0,\lambda_2<0$</td>
   <td style='border-width:1px; border-style: solid;'> $\lambda_{1,2}=\pm \beta i$</td>
   <td style='border-width:1px; border-style: solid;'> $\lambda_{1,2}=\alpha \pm \beta i, \alpha<0$</td>
   <td style='border-width:1px; border-style: solid;'> $\lambda_{1,2}=\alpha \pm \beta i, \alpha>0$</td>
</tr>
<tr>
   <td style='border-width:1px; border-style: solid;'> $A=\begin{pmatrix} 1 & 0 \\ 0 & 0.5\end{pmatrix}$</td>
   <td style='border-width:1px; border-style: solid;'> $A=\begin{pmatrix} -1 & 0 \\ -1 & -0.5\end{pmatrix}$</td>
   <td style='border-width:1px; border-style: solid;'> $A=\begin{pmatrix} 1 & -0.5 \\ 0.5 & -1\end{pmatrix}$</td>
   <td style='border-width:1px; border-style: solid;'> $A=\begin{pmatrix} 0 & -1 \\ 0.5 & 0\end{pmatrix}$</td>
   <td style='border-width:1px; border-style: solid;'> $A=\begin{pmatrix} 0 & -1 \\ 1 & -0.5\end{pmatrix}$</td>
   <td style='border-width:1px; border-style: solid;'> $A=\begin{pmatrix} 0 & -1 \\ 1 & 0.25\end{pmatrix}$</td>
</tr>
<tr>
<td style='border-width:1px; border-style: solid;'><input type=button value="Draw" onclick="doIt(1,0,0,0.5)" /></td>
<td style='border-width:1px; border-style: solid;'><input type=button value="Draw" onclick="doIt(-1,0,-1,-0.5)" /></td>
<td style='border-width:1px; border-style: solid;'><input type=button value="Draw" onclick="doIt(1,-0.5,0.5,-1)" /></td>
<td style='border-width:1px; border-style: solid;'><input type=button value="Draw" onclick="doIt(0,-1,0.5,0)" /></td>
<td style='border-width:1px; border-style: solid;'><input type=button value="Draw" onclick="doIt(0,-1,1,-0.5)" /></td>
<td style='border-width:1px; border-style: solid;'><input type=button value="Draw" onclick="doIt(0,-1,1,0.25)" /></td>
</tr>
</table>
</font>
<p>

<div  id='jxgbox' class='jxgbox' style='float:left; width:450px; height:470px;'></div>

<div  id='jxgbox1' class='jxgbox' style='float:left; width:450px; height:470px;'></div>

Erstellt unter Benutzung von
<a href=http://jsxgraph.uni-bayreuth.de/>JSXGraph</a> und
<a href=http://www.mathjax.org/>MathJax</a>.<br><br>
Rendering: <span id="rendering">x</span>,
Browser:   <span id="browser">x</span><br>




<script type="text/javascript">
{
  checkBrowserName=function (name) { var agent = navigator.userAgent.toLowerCase();  if (agent.indexOf(name.toLowerCase())>-1)      return true;  return false;  }  
	 JXG.Options.text.fontSize = 18;
	 JXG.Options.showCopyright=false;
	 JXG.Options.showNavigation=false;
  if (checkBrowserName('chrome'))   JXG.Options.renderer = 'canvas';
  if (checkBrowserName('opera'))   JXG.Options.renderer = 'canvas';
  if (checkBrowserName('firefox'))   JXG.Options.renderer = 'canvas';

	 JXG.Options.renderer = 'canvas';
	 
  var browser = document.getElementById('browser');  browser.innerHTML= navigator.userAgent;
  var rendering = document.getElementById('rendering'); rendering.innerHTML= JXG.Options.renderer;
  
  // Initialise board
  
  function createboards()
  {
    boardL = JXG.JSXGraph.initBoard('jxgbox', {boundingbox: [-1.5, 10, 20,-10], axis: true, grid: true});
    boardR = JXG.JSXGraph.initBoard('jxgbox1', {boundingbox: [-10.5, 10.5, 10.5,-10.5], axis: true, grid: true});
  }
  
  var myplot=function(board,mydata, attr)
  {
    var X=[],Y=[];
    mydata.get(X,Y);
    var xplot=board.createElement('curve', [X,Y], attr);
    xplot.data=mydata;
    xplot.updateDataArray = function() {
      this.dataX = [];
      this.dataY = [];
      this.data.get(this.dataX, this.dataY);
    }
    return xplot;
  }
  
  
  
  
  function testdataX1()
  {
    this.get=function(X,Y)
    {
      ode();

      for (i=0;i<data.length;i++)
	X[i]=data[i][2],Y[i]=data[i][0];
    }
  }
  function testdataX2()
  {
    this.get=function(X,Y)
    {
      ode();
      for (i=0;i<data.length;i++)
	X[i]=data[i][2],Y[i]=data[i][1];
    }
  }
  function testdataX12()
  {
    this.get=function(X,Y)
    {
      ode();
      for (i=0;i<data.length;i++)
	X[i]=data[i][0],Y[i]=data[i][1];
    }
  }
  
  function updatetext()
  {
    var a11=A11.Value();
    var a12=A12.Value();
    var a21=A21.Value();
    var a22=A22.Value();
    
    var pp=-a11-a22;
    var qq=a11*a22-a21*a12;
    
    var dd=pp*pp*0.25-qq;
    if (dd<0.0) 
      {
	var sd=Math.sqrt(-dd);
	pp=-pp*0.5;
	return "&lambda;1="+ pp.toFixed(2)+ "+"+sd.toFixed(2)+"i\n"+"&lambda;2="+pp.toFixed(2)+ "-"+sd.toFixed(2)+"i";
      }
    else
      {
	var sd=Math.sqrt(dd);
	l1=-pp*0.5+sd;
	l2=-pp*0.5-sd;
	return "&lambda;1="+l1.toFixed(2)+",     &lambda;2="+l2.toFixed(2);
      }

  }

var  slopefield=function() {
  
    xmin=-10; xmax=10; xsep=2;
    ymin=-10; ymax=10; ysep=2;
    seglength=1;
    var xval, yval;
    var xnum = Math.ceil((xmax-xmin)/xsep);
    var ynum = Math.ceil((ymax-ymin)/ysep);

    var iseg;
    for (iseg=0;iseg<nseg; iseg++) boardR.removeObject(seg[iseg]);

    nseg=(xnum+1)*(ynum+1);
    iseg=0;
    for (var i=0;i<=xnum;i++) 
      { 
	xval = xmin + i*xsep;
	for (var j=0;j<=ynum;j++) 
	  { 
	    yval = ymin + j*ysep;
	    
	    vx=a11*xval+a12*yval;
	    vy=a21*xval+a22*yval;
	    len=Math.sqrt(vx*vx+vy*vy);
	    vx=vx/len;
	    vy=vy/len;
	   seg[iseg]=boardR.create('arrow',[
				   [xval-0.5*seglength*vx, yval-0.5*seglength*vy], 
				   [xval+0.5*seglength*vx, yval+0.5*seglength*vy]
				   ], 
			  {strokeWidth:1, dash:0, fixed: true});    
	   iseg=iseg+1;;
	  }
      }
}

  
  function ode() 
  {
    // evaluation interval
    var I = [0, 50];
    // Number of steps. 1000 should be enough
    var N = 1000;

    var achanged=0;
    if (a11!=A11.Value()) { a11=A11.Value(); achanged=1;}
    if (a12!=A12.Value()) { a12=A12.Value(); achanged=1;}
    if (a21!=A21.Value()) { a21=A21.Value(); achanged=1;}
    if (a22!=A22.Value()) { a22=A22.Value(); achanged=1;}
    if (achanged) slopefield();

    
    if (x01!=X12.X()) { x01=X12.X(); achanged=1;}
    if (x02!=X12.Y()) { x02=X12.Y(); achanged=1;}

    if (achanged)
      {
	// Right hand side of the ODE dx/dt = f(t, x)
	var f = function(t, x) {
	  var y = [];
	  y[0] =  a11*x[0]+a12*x[1];
	  y[1] =  a21*x[0]+a22*x[1];
	  return y;
	}
	
	
	var x0 = [x01,x02];
	var xdata = JXG.Math.Numerics.rungeKutta('rk4', x0, I, N, f);
	// to plot the data against time we need the times where the equations were solved
	var q = I[0];
	var h = (I[1]-I[0])/N;
	for(var i=0; i<data.length; i++) {
	  xdata[i].push(q);
	  q += h;
	}
	data=xdata;
      }
  }

  createboards();
  function doIt(x11,x12,x21,x22)
  {
    JXG.JSXGraph.freeBoard(boardL);
    JXG.JSXGraph.freeBoard(boardR);
    createboards();
    x01=100;
    x02=100;
    a11=0;
    a12=0;
    a21=0;
    a22=0;
    data=[];
    seg=[];
    nseg=0;

    A11 = boardL.createElement('slider', [[1.0,9.0],[4.0,9.0],[-1.0,x11,1.0]],{name:'a11',strokeColor:'black',fillColor:'black'});
    A12 = boardL.createElement('slider', [[10.0,9.0],[14.0,9.0],[-1.0,x12,1.0]],{name:'a12',strokeColor:'black',fillColor:'black'});
    
    A21 = boardL.createElement('slider', [[1.0,8.0],[4.0,8.0],[-1.0,x21,1.0]],{name:'a21',strokeColor:'black',fillColor:'black'});
    A22 = boardL.createElement('slider', [[10.0,8.0],[14.0,8.0],[-1.0,x22,1.0]],{name:'a22',strokeColor:'black',fillColor:'black'});
    
    X12 = boardR.create('point',[0,0], {name:'(x1(0), x2(0)',strokeColor:'green',fillColor:'green'});
    
    X10 = boardL.createElement('point', [function () {return 0;},function () {return X12.X();}], {name:'X1',strokeColor:'red',fillColor:'red'});
    X20 = boardL.createElement('point', [function () {return 0;},function () {return X12.Y();}], {name:'X2',strokeColor:'blue',fillColor:'blue'});
    
    
    px1=myplot(boardL,new testdataX1(),{strokeColor:'red', strokeWidth:'2px'})
    px2=myplot(boardL,new testdataX2(),{strokeColor:'blue', strokeWidth:'2px'})
    px12=myplot(boardR,new testdataX12(),{strokeColor:'green', strokeWidth:'2px'})
    
    txt=boardL.createElement('text', [1.0,7.0,function () { return updatetext();}]);


  }
}

</script>
~~~

