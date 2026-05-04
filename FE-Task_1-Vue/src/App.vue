<script setup>
import { computed, ref } from 'vue';

const shareProfiles = [
  { value: 'public_forum', label: 'Public Forum' },
  { value: 'service_vendor', label: 'Service Vendor' },
  { value: 'personal_archive', label: 'Personal Archive' },
];

const preserveKeyOptions = [
  { value: 'order_id', id: 'preserve-query-key-order-id' },
  { value: 'invoice_id', id: 'preserve-query-key-invoice-id' },
  { value: 'product_id', id: 'preserve-query-key-product-id' },
];

const sourceText = ref('');
const selectedFileName = ref('');
const shareProfile = ref('public_forum');
const exportLabel = ref('Sanitized Export');
const preserveQueryKeys = ref([]);
const statusMessage = ref(
  'Validation, sanitization, export, and logging behavior are ready to be implemented here.'
);
const sanitizedPreview = ref('');

const summaryLines = computed(() => {
  if (sanitizedPreview.value) {
    return ['Replace this placeholder with real detection and replacement counts.'];
  }

  return ['Summary will appear after sanitization.'];
});

const normalizationFlags = computed(() => {
  return ['Normalization flags will appear after sanitization.'];
});

function togglePreserveKey(key) {
  if (preserveQueryKeys.value.includes(key)) {
    preserveQueryKeys.value = preserveQueryKeys.value.filter((item) => item !== key);
    return;
  }

  preserveQueryKeys.value = [...preserveQueryKeys.value, key];
}

function handleFileChange(event) {
  const file = event.target.files?.[0] ?? null;
  selectedFileName.value = file?.name ?? '';

  if (file) {
    statusMessage.value =
      'A file has been selected. File parsing and validation can now be implemented.';
    return;
  }

  statusMessage.value =
    'Validation, sanitization, export, and logging behavior are ready to be implemented here.';
}

function handleSanitize() {
  sanitizedPreview.value = '';
  statusMessage.value =
    'Implement the sanitization workflow in src/App.vue or split it into dedicated modules.';
}
</script>

<template>
  <div id="app-root" class="app-shell">
    <header class="hero">
      <p class="eyebrow">Privacy Workspace</p>
      <h1 id="page-title">Privacy-Safe Snippet Sanitizer</h1>
      <p class="hero-copy">
        This workspace focuses on the sanitizer flow. The UI shape and stable
        DOM IDs are already in place so the remaining implementation can stay
        focused on behavior.
      </p>
    </header>

    <main class="layout-grid">
      <section id="input-panel" class="panel">
        <div class="panel-header">
          <div>
            <p class="panel-kicker">Input</p>
            <h2>Raw Source</h2>
          </div>
        </div>

        <label class="field" for="source-textarea">
          <span>Paste source text</span>
          <textarea
            id="source-textarea"
            :value="sourceText"
            placeholder="Paste notes, receipts, logs, or transcripts here."
            spellcheck="false"
            @input="sourceText = $event.target.value"
          />
        </label>

        <label class="field" for="source-file-input">
          <span>Import local file</span>
          <input
            id="source-file-input"
            type="file"
            accept=".txt,.json,application/json,text/plain"
            @change="handleFileChange"
          />
        </label>

        <p id="source-file-help" class="help-text">
          Only the file input control is provided here. Size checks, JSON shape
          validation, and file parsing still need implementation.
        </p>

        <p v-if="selectedFileName" class="help-text">
          Selected file: {{ selectedFileName }}
        </p>
      </section>

      <section id="policy-panel" class="panel">
        <div class="panel-header">
          <div>
            <p class="panel-kicker">Configuration</p>
            <h2>Policy Settings</h2>
          </div>
        </div>

        <label class="field" for="share-profile-select">
          <span>Share profile</span>
          <select
            id="share-profile-select"
            :value="shareProfile"
            @change="shareProfile = $event.target.value"
          >
            <option
              v-for="profile in shareProfiles"
              :key="profile.value"
              :value="profile.value"
            >
              {{ profile.label }}
            </option>
          </select>
        </label>

        <label class="field" for="export-label-input">
          <span>Export label</span>
          <input
            id="export-label-input"
            type="text"
            maxlength="40"
            :value="exportLabel"
            placeholder="Sanitized Export"
            @input="exportLabel = $event.target.value"
          />
        </label>

        <fieldset id="preserve-query-keys-group" class="field checkbox-group">
          <legend>Preserve query keys</legend>

          <label
            v-for="option in preserveKeyOptions"
            :key="option.value"
            class="checkbox-row"
            :for="option.id"
          >
            <input
              :id="option.id"
              type="checkbox"
              :checked="preserveQueryKeys.includes(option.value)"
              @change="togglePreserveKey(option.value)"
            />
            <span>{{ option.value }}</span>
          </label>
        </fieldset>
      </section>

      <section id="validation-banner" class="panel status-panel" aria-live="polite">
        <p class="panel-kicker">Status</p>
        <p class="status-copy">{{ statusMessage }}</p>
      </section>

      <section id="preview-panel" class="panel">
        <div class="panel-header">
          <div>
            <p class="panel-kicker">Output</p>
            <h2>Sanitized Preview</h2>
          </div>
        </div>

        <pre id="sanitized-preview" class="preview-block">{{ sanitizedPreview || 'No sanitized output yet.' }}</pre>
      </section>

      <section id="summary-panel" class="panel">
        <div class="panel-header">
          <div>
            <p class="panel-kicker">Summary</p>
            <h2>Redactions And Normalization</h2>
          </div>
        </div>

        <div class="summary-grid">
          <div>
            <h3>Redaction Summary</h3>
            <ul id="redaction-summary">
              <li v-for="line in summaryLines" :key="line">{{ line }}</li>
            </ul>
          </div>

          <div>
            <h3>Normalization Flags</h3>
            <ul id="normalization-flags">
              <li v-for="flag in normalizationFlags" :key="flag">{{ flag }}</li>
            </ul>
          </div>
        </div>
      </section>

      <section id="export-panel" class="panel">
        <div class="panel-header">
          <div>
            <p class="panel-kicker">Actions</p>
            <h2>Export And Clear</h2>
          </div>
        </div>

        <div class="button-grid">
          <button id="sanitize-button" type="button" class="primary-button" @click="handleSanitize">
            Run Placeholder Action
          </button>
          <button id="copy-sanitized-button" type="button" disabled>
            Copy Sanitized Text
          </button>
          <button id="download-export-button" type="button" disabled>
            Download Export JSON
          </button>
          <button id="clear-workspace-button" type="button" disabled>
            Clear Workspace
          </button>
        </div>

        <p class="help-text">
          These buttons already provide stable UI hooks. Their interactive
          behavior still needs implementation.
        </p>
      </section>
    </main>
  </div>
</template>

