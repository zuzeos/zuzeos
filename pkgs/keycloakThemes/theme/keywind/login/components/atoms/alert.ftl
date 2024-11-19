<#macro kw color="">
  <#switch color>
    <#case "error">
      <#assign colorClass="bg-red-900 text-red-300">
      <#break>
    <#case "info">
      <#assign colorClass="bg-blue-900 text-blue-300">
      <#break>
    <#case "success">
      <#assign colorClass="bg-green-900 text-green-300">
      <#break>
    <#case "warning">
      <#assign colorClass="bg-orange-900 text-orange-300">
      <#break>
    <#default>
      <#assign colorClass="bg-blue-900 text-blue-300">
  </#switch>

  <div class="${colorClass} p-4 rounded-lg text-sm" role="alert">
    <#nested>
  </div>
</#macro>
