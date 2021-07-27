package io.pact.plugins.jvm

interface ContentMatcher {
  val isCore: Boolean
}

data class CatalogueContentMatcher(
  val catalogueEntry: CatalogueEntry
): ContentMatcher {
  override val isCore: Boolean
    get() = catalogueEntry.providerType == CatalogueEntryProviderType.CORE
}
