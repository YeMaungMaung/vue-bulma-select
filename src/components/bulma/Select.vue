<template>
  <div :class="containerClasses" >
    <input
      ref="search"
      v-model="searchField"
      :class="placeholderClasses"
      :readonly="!search"
      :placeholder="placeholder"
      @blur="close"
      @input="inputSearch"
      @click.self="toggleOpened">

    <transition name="vuebulmaselect-slide-fade">
      <div v-show="opened" :style="optionsStyles" :class="optionsClasses">
        <template v-if="options.length === 0">
          <button disabled class="button is-white bulma-select__option">
            <slot name="no-results">No options found.</slot>
          </button>
        </template>
        <template v-else>
          <button
            v-for="(option, i) in options"
            @click="selectOption(i)"
            :class="['button is-white', selected === i ? 'is-info' : '', 'bulma-select__option']">
            {{ label !== undefined ? option[label] : option }}
          </button>
        </template>
      </div>
    </transition>
  </div>
</template>

<script>
// Export the component itself
export default {
  name: 'bulma-select',
  props: {
    // Select placeholder
    placeholder: {
      type: String,
      default: 'Select...'
    },
    // Options
    options: {
      type: Array,
      default: () => []
    },
    // Options label
    label: {
      type: String
    },
    // v-model value
    value: {
      type: null,
      default: null
    },
    // Has search?
    search: {
      type: Boolean,
      default: false
    },
    // Max items displayed
    maxItems: {
      type: Number,
      default: 5
    }
  },
  // Component inner state
  data () {
    //
    return {
      opened: false,
      searchField: '',
      saveSearchField: '',
      selected: undefined
    }
  },
  // Computed properties
  computed: {
    // Container computed classes
    containerClasses () {
      return ['bulma-select__container', {'bulma-select__container--active': this.opened}]
    },
    // Placeholder computed classes
    placeholderClasses () {
      return ['bulma-select__placeholder input', {'is-hovered': this.opened}]
    },
    // Options computed classes
    optionsClasses () {
      return [{'is-hovered': this.opened}, 'bulma-select__options']
    },
    // Options styles
    optionsStyles () {
      //
      let styles = {}

      //
      if (this.options.length > this.maxItems) {
        styles.height = 35 * this.maxItems + 'px'
      }

      // Return the styles
      return styles
    },
    // Selected item
    selectedItem () { return this.options[this.selected] },
    // Text for the selected option
    textSelected () {
      //
      if (this.options[this.selected] === undefined) { return '' }

      //
      return this.label !== undefined ? this.selectedItem[this.label] : this.selectedItem
    }
  },
  // Methods
  methods: {
    // Toggle the opened property
    toggleOpened () {
      this.opened ? this.close() : this.open()
    },
    // Open the select
    open () {
      // Primitive return
      if (this.opened) { return }

      // Definitions
      this.searchField = this.saveSearchField
      this.inputSearch()
      this.opened = true
      this.$refs.search.focus()
    },
    // Close the select
    close () {
      // Primitive return
      if (!this.opened) { return }

      // Definitions
      this.opened = false
      this.saveSearchField = this.searchField
      this.searchField = this.textSelected
      this.$refs.search.blur()
    },
    // Set the selected using v-model value
    selectVModel () {
      if (this.options.indexOf(this.value) === -1) { return }
      this.selected = this.options.indexOf(this.value)
    },
    // Select a value based on the index
    selectOption (i) {
      //
      this.selected = i
      this.searchField = this.textSelected
      this.saveSearchField = ''

      // Emit!
      this.$emit('input', this.options[this.selected])
    },
    // Search items
    inputSearch () {
      //
      this.$emit('type', this.searchField)
    }
  },
  // Watchers
  watch: {
    // Value changed
    value () {
      this.selectVModel()
    },
    // Options also change
    options (_, old) {
      //
      let i = this.options.indexOf(old[this.selected])
      if (i > -1) { this.selected = i }
    }
  },
  // When the component is created
  created () {
    // do it
    this.selectVModel()
  }
}
</script>

<style lang="sass">
// Import bulma stuff
@import '~bulma/sass/utilities/_all'
@import "~bulma/sass/elements/button"
@import "~bulma/sass/elements/form"

//
.bulma-select
  &__container
    @extend .select
    position: relative
    width: 100%
    &:after
      transition: all 0.2s ease
    &--active
      &:after
        transform: rotate(-225deg)
        top: 60% !important
  &__placeholder
    @extend select
    box-sizing: border-box
    text-align: left
    width: 100%
    &.is-hovered
      border-radius: $input-radius $input-radius 0 0
  &__options
    +input
    display: block
    overflow: auto
    padding: 0
    z-index: 5
    width: 100%
    height: auto
    box-sizing: border-box
    border-top: 0
    border-radius: 0 0 $input-radius $input-radius
    position: absolute
  &__option
    width: 100%
    text-align: left
    border-radius: 0
    display: block

// Transition definition
.vuebulmaselect-slide-fade
  &-enter-active
    transition: all 0.2s ease
  &-leave-active
    transition: all 0.1s cubic-bezier(1.0, 0.5, 0.8, 1.0)
  &-enter, &-leave-active
    padding-top: 10px
    opacity: 0
</style>
