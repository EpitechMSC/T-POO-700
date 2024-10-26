import{d as h,r as l,p as x,c as p,a as s,q as V,b as n,m as g,e as i,t as b,f as k,h as u,i as c,_ as B}from"./index-BHfDbzrd.js";import{u as w}from"./users-msOP0oqz.js";import{B as R,a as C}from"./BaseButton-D2I3K-mJ.js";const N=h({name:"RegisterPage",components:{BaseInput:R,BaseButton:C},setup(){const r=l(""),e=l(""),t=l(null),m=x(),d=w();return{username:r,email:e,error:t,handleRegister:async()=>{if(t.value=null,!r.value||!e.value){t.value="Tous les champs sont obligatoires.";return}try{await d.createUser({username:r.value,email:e.value}),m.push("/login")}catch(o){o instanceof Error?t.value=o.message||"Erreur lors de l'enregistrement. Veuillez réessayer.":t.value="Erreur inconnue lors de l'enregistrement."}}}}}),S={class:"bg-gray-50 dark:bg-gray-900"},z={class:"flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0"},E={class:"w-full bg-white rounded-lg shadow dark:border md:mt-0 sm:max-w-md xl:p-0 dark:bg-gray-800 dark:border-gray-700"},U={class:"p-6 space-y-4 md:space-y-6 sm:p-8"},_={class:"text-sm font-light text-gray-500 dark:text-gray-400"},$={key:0,class:"text-red-500 text-sm mt-2"};function q(r,e,t,m,d,f){const o=u("BaseInput"),y=u("BaseButton"),v=u("router-link");return c(),p("section",S,[s("div",z,[s("div",E,[s("div",U,[e[6]||(e[6]=s("h1",{class:"text-xl font-bold leading-tight tracking-tight text-gray-900 md:text-2xl dark:text-white"}," Créez votre compte ",-1)),s("form",{class:"space-y-4 md:space-y-6",onSubmit:e[2]||(e[2]=V((...a)=>r.handleRegister&&r.handleRegister(...a),["prevent"]))},[n(o,{modelValue:r.username,"onUpdate:modelValue":e[0]||(e[0]=a=>r.username=a),label:"Nom d'utilisateur",name:"username",id:"username",placeholder:"Votre nom d'utilisateur",required:"",error:r.error},null,8,["modelValue","error"]),n(o,{modelValue:r.email,"onUpdate:modelValue":e[1]||(e[1]=a=>r.email=a),type:"email",label:"Votre email",name:"email",id:"email",placeholder:"name@company.com",required:"",error:r.error},null,8,["modelValue","error"]),n(y,{type:"submit",variant:"primary",fullWidth:!0},{default:g(()=>e[3]||(e[3]=[i(" S'enregistrer ")])),_:1})],32),s("p",_,[e[5]||(e[5]=i(" Vous avez déjà un compte ? ")),n(v,{to:"/login",class:"font-medium text-gray-600 hover:underline dark:text-gray-500"},{default:g(()=>e[4]||(e[4]=[i(" Connectez-vous ")])),_:1})]),r.error?(c(),p("div",$,b(r.error),1)):k("",!0)])])])])}const T=B(N,[["render",q]]);export{T as default};