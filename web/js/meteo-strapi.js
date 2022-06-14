//var meteo = require("./meteo.json")
//import meteoPromesse from "./meteo-data-strapi.js"
import * as mark from "./marked.min.js"

////////////
// VARIABLES
////////////

const svg0 = "<svg width=\"2em\" height=\"2em\" viewBox=\"0 0 16 16\" xmlns=\"http://www.w3.org/2000/svg\" class=\"bi bi-circle-fill\" fill=\"#666666\"><circle cx=\"8\" cy=\"8\" r=\"8\"/></svg>"

const svgBloquant = "<svg width=\"2em\" height=\"2em\" viewBox=\"0 0 16 16\" xmlns=\"http://www.w3.org/2000/svg\" class=\"bi bi-lightning-fill\" fill=\"#94124E\"><path fill-rule=\"evenodd\" d=\"M5.52.359A.5.5 0 0 1 6 0h4a.5.5 0 0 1 .474.658L8.694 6H12.5a.5.5 0 0 1 .395.807l-7 9a.5.5 0 0 1-.873-.454L6.823 9.5H3.5a.5.5 0 0 1-.48-.641l2.5-8.5z\"/></svg>"

const svgPerturbations = "<svg width=\"2em\" height=\"2em\" viewBox=\"0 0 16 16\" xmlns=\"http://www.w3.org/2000/svg\" class=\"bi bi-umbrella-fill\" fill=\"#945400\"><path fill-rule=\"evenodd\" d=\"M8 0a.5.5 0 0 1 .5.5v.514C12.625 1.238 16 4.22 16 8c0 0 0 .5-.5.5-.149 0-.352-.145-.352-.145l-.004-.004-.025-.023a3.484 3.484 0 0 0-.555-.394A3.166 3.166 0 0 0 13 7.5c-.638 0-1.178.213-1.564.434a3.484 3.484 0 0 0-.555.394l-.025.023-.003.003s-.204.146-.353.146-.352-.145-.352-.145l-.004-.004-.025-.023a3.484 3.484 0 0 0-.555-.394 3.3 3.3 0 0 0-1.064-.39V13.5H8h.5v.039l-.005.083a2.958 2.958 0 0 1-.298 1.102 2.257 2.257 0 0 1-.763.88C7.06 15.851 6.587 16 6 16s-1.061-.148-1.434-.396a2.255 2.255 0 0 1-.763-.88 2.958 2.958 0 0 1-.302-1.185v-.025l-.001-.009v-.003s0-.002.5-.002h-.5V13a.5.5 0 0 1 1 0v.506l.003.044a1.958 1.958 0 0 0 .195.726c.095.191.23.367.423.495.19.127.466.229.879.229s.689-.102.879-.229c.193-.128.328-.304.424-.495a1.958 1.958 0 0 0 .197-.77V7.544a3.3 3.3 0 0 0-1.064.39 3.482 3.482 0 0 0-.58.417l-.004.004S5.65 8.5 5.5 8.5c-.149 0-.352-.145-.352-.145l-.004-.004a3.482 3.482 0 0 0-.58-.417A3.166 3.166 0 0 0 3 7.5c-.638 0-1.177.213-1.564.434a3.482 3.482 0 0 0-.58.417l-.004.004S.65 8.5.5 8.5C0 8.5 0 8 0 8c0-3.78 3.375-6.762 7.5-6.986V.5A.5.5 0 0 1 8 0z\"/></svg>"

const svgHabituel = "<svg width=\"2em\" height=\"2em\" viewBox=\"0 0 16 16\" xmlns=\"http://www.w3.org/2000/svg\" class=\"bi bi-brightness-high-fill\" fill=\"#007566\"><path fill-rule=\"evenodd\" d=\"M12 8a4 4 0 1 1-8 0 4 4 0 0 1 8 0zM8 0a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 0zm0 13a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 13zm8-5a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1h2a.5.5 0 0 1 .5.5zM3 8a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1h2A.5.5 0 0 1 3 8zm10.657-5.657a.5.5 0 0 1 0 .707l-1.414 1.415a.5.5 0 1 1-.707-.708l1.414-1.414a.5.5 0 0 1 .707 0zm-9.193 9.193a.5.5 0 0 1 0 .707L3.05 13.657a.5.5 0 0 1-.707-.707l1.414-1.414a.5.5 0 0 1 .707 0zm9.193 2.121a.5.5 0 0 1-.707 0l-1.414-1.414a.5.5 0 0 1 .707-.707l1.414 1.414a.5.5 0 0 1 0 .707zM4.464 4.465a.5.5 0 0 1-.707 0L2.343 3.05a.5.5 0 1 1 .707-.707l1.414 1.414a.5.5 0 0 1 0 .708z\"/></svg>"


////////////
// FONCTIONS
////////////

function buildSvg(lvl) {
	if ( 0 == lvl ) 
	{
    	return svg0
  }
  if ( 1 == lvl ) 
	{
    	return svgHabituel
  }
  if ( 2 == lvl ) 
	{
    	return svgPerturbations
  }
  if ( 3 == lvl ) 
	{
    	return svgBloquant
  }
}


function md2html(md) {
  //console.log(marked(md));
  var description = ""
  if (null != md) {description = md}
  return marked(description);
}

function triLibelleASC( a, b ) {
  return a.libelle.localeCompare(b.libelle)
}

function triQosDESC( a, b ) {
  return ( b.qualiteDeService.key - a.qualiteDeService.key)
}


////////////
// TEST
////////////

if(Array.prototype.forEach === undefined ) {
  document.querySelector("#test").innerHTML+=`Ce service ne supporte pas le navigateur que vous utilisez. <br>Merci d'utiliser une version récente de Firefox, Chrome ou Edge.`
}
else{


////////////
// DATE MAJ
////////////

//document.querySelector("#modification").innerHTML+=`${meteo.datemaj}`


//////////// 
// METEO
//////////// 

/*
${service["description"]}
${md2html(service["description"])}

meteoPromesse
.then(data => console.log(data)).then(data => console.log(data))
*/



fetch('https://www.toutatice.fr/strapi/services')
  .then(response => response.json())
  .then(data => 
          {
            //console.log(data)
            const tableau = data
            const tabdate = data

            document.querySelector("#modification").innerHTML += "Dernière mise à jour : "
            const lastUpdatedDate = new Date(Math.max(...tabdate.map((e) => new Date(e.updated_at).getTime())))
            document.querySelector("#modification").innerHTML += lastUpdatedDate.toLocaleString('fr-fr')

            // Tri
            tableau.sort( triLibelleASC );
            tableau.sort( triQosDESC );

            tableau.forEach((service) => {
                  document.querySelector("#meteo-inner").innerHTML+=`
            <div class="col-lg-3">
              <!-- Tuile -->
              <div class="tuile tuile-${service["qualiteDeService"].key} h-100">
              
                <div class="tuile-inner-${service["qualiteDeService"].key} h-100">

                  <div class="row">

                    <div class="col-md-12 text-center">
                      ${buildSvg(service["qualiteDeService"].key)} 
                    </div>
                  </div>

                  <div class="row">
                    <div class="col-md-12 text-center">
                      <h3>${service["libelle"]}</h3>
                    </div>
                  </div>

                  <div class="row">
                    <div class="col-md-12 text-center tuile-qos-${service["qualiteDeService"].key}">
                      <span>${service["qualiteDeService"].libelle}</span>
                    </div>
                  </div>

                  <div class="row">
                    <div class="col-md-12">
                      <div class="card-text">${md2html(service["description"])}</div>
                    </div>
                  </div>

                </div>

              </div>
            </div>
          `
          }
        )
          }
          )

/*
meteo.services.forEach((service) =>{
  document.querySelector("#meteo-inner").innerHTML+=`
    	<div class="col-lg-3">
        <!-- Tuile -->
        <div class="tuile-${service["service-qos"]} h-100">
        
          <div class="tuile-inner-${service["service-qos"]} h-100">

            <div class="row">

              <div class="col-md-12 text-center">
                ${buildSvg(service["service-qos"])}
              </div>
            </div>

            <div class="row">
              <div class="col-md-12 text-center">
                <h3>${service["service-libelle"]}</h3>
              </div>

            </div>

            <div class="row">
              <div class="col-md-12">
                <p class="card-text">${service["service-description"]}</p>
              </div>
            </div>

          </div>

        </div>
      </div>
    `
})
*/        
}          