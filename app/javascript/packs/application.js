// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import * as bootstrap from "bootstrap"
import 'bootstrap-icons/font/bootstrap-icons.css'

Rails.start()
Turbolinks.start()
ActiveStorage.start()

//document.addEventListener('turbolinks:load', () => {
//  document.body.addEventListener("ajax:success", (event) => {
//
//
//    console.log('foiiiiiiiiiiiiiiiiii');
//    event.preventDefault();
//    const [data, status, xhr] = event.detail;
//  });
//});

 
window.addEventListener("load", () => {
  const element = document.querySelector("#random_id");
  element.addEventListener("ajax:success", (event) => {
    const [_data, _status, xhr] = event.detail;
    var shippings = document.querySelector("#data_return");
    shippings.appendChild(showShippings(_data));
  });
  element.addEventListener("ajax:error", () => {
    event.preventDefault();
    element.insertAdjacentHTML("beforeend", "<p>ERROR</p>");
  });
});

function showShippings(jsonObj) {
  var shippings = jsonObj;

  var section = document.createElement('section');
  for (var i = 0; i < shippings.length; i++) {
    var myArticle = document.createElement('article');
    var myH2 = document.createElement('h2');
    var myPara1 = document.createElement('p');
    var myPara2 = document.createElement('p');

    myH2.textContent = shippings[i].name;
    myPara1.textContent = 'Valor: ' + shippings[i].price;
    myPara2.textContent = 'Tempo de entrega: ' + shippings[i].arrival_time;

    myArticle.appendChild(myH2);
    myArticle.appendChild(myPara1);
    myArticle.appendChild(myPara2);

    section.appendChild(myArticle)
  }
  return section;
}