import{d as i,j as c,_ as d,c as a,a as e,b as m,f as u,h as p,i as r}from"./index-BHfDbzrd.js";import{S as f}from"./SettingsNavigationMenu-CsWxikFR.js";const g=i({name:"SettingsDocuments",components:{SettingsNavigationMenu:f},setup(){var n;const t=c(),s=window.location.origin,o=(n=t.contratOfConnectedUser)==null?void 0:n.temps;return{baseUrl:s,contractDetails:o}}}),h={class:"mx-4 min-h-screen max-w-screen-xl sm:mx-8 xl:mx-auto"},x={class:"grid grid-cols-8 pt-3 sm:grid-cols-10"},_={class:"col-span-8 overflow-hidden rounded-xl sm:bg-gray-50 sm:px-8 sm:shadow"},b={class:"mt-8"},v=["href"],E={key:0},S=["href"],D=["href"],k=["href"];function N(t,s,o,n,U,w){const l=p("SettingsNavigationMenu");return r(),a("div",h,[s[2]||(s[2]=e("h1",{class:"border-b py-6 text-4xl font-semibold"},"Documents",-1)),e("div",x,[m(l),e("div",_,[s[0]||(s[0]=e("div",{class:"pt-4"},[e("h1",{class:"py-2 text-2xl font-semibold"}," Vos Documents à Télécharger ")],-1)),s[1]||(s[1]=e("hr",{class:"mt-4 mb-8"},null,-1)),e("div",b,[e("ul",null,[e("li",null,[e("a",{href:t.baseUrl+"/api/documents/reglementation-heures-de-travail.pdf",target:"_blank",class:"text-blue-600 underline"}," Réglementation des Heures de Travail ",8,v)]),t.contractDetails?(r(),a("li",E,[e("a",{href:t.baseUrl+"/api/documents/contrat_"+t.contractDetails+"h.pdf",class:"text-blue-600 underline"}," Télécharger le contrat ",8,S)])):u("",!0),e("li",null,[e("a",{href:t.baseUrl+"/api/documents/reglement.pdf",target:"_blank",class:"text-blue-600 underline"}," Réglement Intérieur ",8,D)]),e("li",null,[e("a",{href:t.baseUrl+"/api/documents/FAQ.pdf",target:"_blank",class:"text-blue-600 underline"}," FAQ ",8,k)])])])])])])}const V=d(g,[["render",N]]);export{V as default};
