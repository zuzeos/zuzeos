<#macro kw color="" component="button" size="" rest...>
  <#switch color>
    <#case "primary">
      <#assign colorClass="bg-primary-400 text-white focus:ring-primary-400 ring-offset-dark-800 hover:bg-primary-300">
      <#break>
    <#case "secondary">
      <#assign colorClass="bg-secondary-800 text-secondary-300 focus:ring-secondary-800 ring-offset-dark-800 hover:bg-secondary-700 hover:text-secondary-100">
      <#break>
    <#default>
      <#assign colorClass="bg-primary-400 text-white focus:ring-primary-400 ring-offset-dark-800 hover:bg-primary-300">
  </#switch>

  <#switch size>
    <#case "medium">
      <#assign sizeClass="px-4 py-2 text-sm">
      <#break>
    <#case "small">
      <#assign sizeClass="px-2 py-1 text-xs">
      <#break>
    <#default>
      <#assign sizeClass="px-4 py-2 text-sm">
  </#switch>

  <${component}
    class="${colorClass} ${sizeClass} flex justify-center relative rounded w-full focus:outline-none focus:ring-2 focus:ring-offset-2"

    <#list rest as attrName, attrValue>
      ${attrName}="${attrValue}"
    </#list>
  >
    <#nested>
  </${component}>
</#macro>
