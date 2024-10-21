import{d as p,k as l,_ as g,o as s,c as d,t as i,h as u,l as c,v as b,b as m,n as y,m as k}from"./index-CfL1cJoF.js";const h={modelValue:{type:String,required:!0},label:{type:String,required:!1},type:{type:String,default:"text"},name:{type:String,required:!0},id:{type:String,required:!0},placeholder:{type:String,required:!1},required:{type:Boolean,default:!1},darkMode:{type:Boolean,default:!1},error:{type:String,required:!1}},B=p({name:"BaseInput",props:h,emits:["update:modelValue"],setup(e,{emit:r}){const o=l(()=>e.darkMode?"dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500":""),a=l({get(){return e.modelValue},set(t){r("update:modelValue",t)}});return{darkModeClasses:o,internalValue:a}}}),v={class:"input-wrapper"},C=["for"],$=["id","type","name","placeholder","required"],S={key:1,class:"text-red-500 text-sm mt-1"};function q(e,r,o,a,t,f){return s(),d("div",v,[e.label?(s(),d("label",{key:0,for:e.id,class:"block mb-2 text-sm font-medium text-gray-900 dark:text-white"},i(e.label),9,C)):u("",!0),c(m("input",{id:e.id,"onUpdate:modelValue":r[0]||(r[0]=n=>e.internalValue=n),type:e.type,name:e.name,placeholder:e.placeholder,class:y(["bg-gray-50 border border-gray-300 text-gray-900 rounded-lg focus:ring-gray-600 focus:border-gray-600 block w-full p-2.5",e.darkModeClasses,e.error?"border-red-500 focus:border-red-500":""]),required:e.required},null,10,$),[[b,e.internalValue]]),e.error?(s(),d("p",S,i(e.error),1)):u("",!0)])}const _=g(B,[["render",q],["__scopeId","data-v-e7725b89"]]),V={type:{type:String,default:"button"},disabled:{type:Boolean,default:!1},variant:{type:String,default:"primary"},fullWidth:{type:Boolean,default:!1}},w=p({name:"BaseButton",props:V,setup(e){return{buttonClasses:l(()=>{const a="font-medium rounded-lg text-sm px-5 py-2.5 text-center focus:outline-none focus:ring-4",t={primary:"text-white bg-gray-600 hover:bg-gray-700 focus:ring-gray-300 dark:bg-gray-600 dark:hover:bg-gray-700 dark:focus:ring-gray-800",secondary:"text-gray-700 bg-gray-200 hover:bg-gray-300 focus:ring-gray-400 dark:bg-gray-700 dark:hover:bg-gray-600 dark:focus:ring-gray-500",danger:"text-white bg-red-600 hover:bg-red-700 focus:ring-red-300 dark:bg-red-600 dark:hover:bg-red-700 dark:focus:ring-red-800"};return[a,t[e.variant]||t.primary,e.fullWidth?"w-full":"",e.disabled?"opacity-50 cursor-not-allowed":""].join(" ")}),onClick:a=>{e.disabled&&a.preventDefault()}}}}),M=["type","disabled"];function D(e,r,o,a,t,f){return s(),d("button",{type:e.type,class:y(e.buttonClasses),disabled:e.disabled,onClick:r[0]||(r[0]=(...n)=>e.onClick&&e.onClick(...n))},[k(e.$slots,"default")],10,M)}const N=g(w,[["render",D]]);export{_ as B,N as a};
