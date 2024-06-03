import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{attribute}

pub type TimingDeclaration {
  Seconds(Int)
  Milliseconds(Int)
}

pub type Swap {
  InnerHTML
  OuterHTML
  After
  Afterbegin
  Beforebegin
  Beforeend
  Afterend
  Delete
  SwapNone
}

pub type Scroll {
  Top
  Bottom
}

pub type SwapOption {
  Transition(Bool)
  Swap(TimingDeclaration)
  Settle(TimingDeclaration)
  IgnoreTitle(Bool)
  Scroll(Scroll)
  Show(Scroll)
  FocusScroll(Bool)
}

pub type ExtendedCssSelector {
  Standard(css_selector: String)
  Document
  Window
  Closest(css_selector: String)
  Find(css_selector: String)
  Next(css_selector: Option(String))
  Previous(css_selector: Option(String))
  This
}

pub type Queue {
  First
  Last
  All
  QueueNone
}

pub type Event {
  Event(event: String, modifiers: List(EventModifier))
}

pub type EventModifier {
  Once
  Changed
  Delay(TimingDeclaration)
  Throttle(TimingDeclaration)
  From(extended_css_selector: ExtendedCssSelector)
  Target(css_selector: String)
  Consume
  Queue(Queue)
}

fn swap_to_string(swap: Swap) {
  case swap {
    InnerHTML -> "innerHTML"
    OuterHTML -> "outerHTML"
    After -> "after"
    Afterbegin -> "afterBegin"
    Beforebegin -> "beforeBegin"
    Beforeend -> "beforeEnd"
    Afterend -> "afterEnd"
    Delete -> "delete"
    SwapNone -> "none"
  }
}

fn swap_option_to_string(swap_option: SwapOption) {
  case swap_option {
    Transition(True) -> "transition:true"
    Transition(False) -> "transition:false"
    Swap(timing_declaration) ->
      "swap:" <> timing_declaration_to_string(timing_declaration)
    Settle(timing_declaration) ->
      "settle:" <> timing_declaration_to_string(timing_declaration)
    IgnoreTitle(True) -> "ignoreTitle:true"
    IgnoreTitle(False) -> "ignoreTitle:false"
    Scroll(Top) -> "scroll:top"
    Scroll(Bottom) -> "scroll:bottom"
    Show(Top) -> "show:top"
    Show(Bottom) -> "show:bottom"
    FocusScroll(True) -> "focus-scroll:true"
    FocusScroll(False) -> "focus-scroll:false"
  }
}

fn extended_css_selector_to_string(
  extended_css_selector: ExtendedCssSelector,
) -> String {
  case extended_css_selector {
    Standard(css_selector) -> css_selector
    Document -> "document"
    Window -> "window"
    Closest(css_selector) -> "closest " <> css_selector
    Find(css_selector) -> "find " <> css_selector
    Next(css_selector) -> "next " <> option.unwrap(css_selector, "")
    Previous(css_selector) -> "previous " <> option.unwrap(css_selector, "")
    This -> "this"
  }
}

fn queue_to_string(queue: Queue) -> String {
  case queue {
    First -> "first"
    Last -> "last"
    All -> "all"
    QueueNone -> "none"
  }
}

fn timing_declaration_to_string(timing: TimingDeclaration) {
  case timing {
    Seconds(n) -> int.to_string(n) <> "s"
    Milliseconds(n) -> int.to_string(n) <> "ms"
  }
}

fn event_to_string(event: Event) {
  event.event
  <> list.map(event.modifiers, fn(e) { " " <> event_modifier_to_string(e) })
  |> string.join("")
}

fn event_modifier_to_string(event_modifier event_modifier: EventModifier) {
  case event_modifier {
    Once -> "once"
    Changed -> "changed"
    Delay(timing) -> "delay:" <> timing_declaration_to_string(timing)
    Throttle(timing) -> "throttle:" <> timing_declaration_to_string(timing)
    From(extended_css_selector) ->
      "from:" <> extended_css_selector_to_string(extended_css_selector)
    Target(css_selector) -> "target:" <> css_selector
    Consume -> "consume"
    Queue(queue) -> "queue:" <> queue_to_string(queue)
  }
}

pub fn get(url url: String) {
  attribute("hx-get", url)
}

pub fn post(url url: String) {
  attribute("hx-post", url)
}

pub fn put(url url: String) {
  attribute("hx-put", url)
}

pub fn patch(url url: String) {
  attribute("hx-patch", url)
}

pub fn delete(url url: String) {
  attribute("hx-delete", url)
}

pub fn trigger(events: List(Event)) {
  let events =
    events
    |> list.map(event_to_string)
    |> string.join(", ")
  attribute("hx-trigger", events)
}

pub fn trigger_polling(
  timing_declaration timing: TimingDeclaration,
  filters filters: Option(String),
) {
  case filters {
    Some(filters) ->
      attribute(
        "hx-trigger",
        "every "
          <> timing_declaration_to_string(timing)
          <> " ["
          <> filters
          <> "]",
      )
    None ->
      attribute("hx-trigger", "every " <> timing_declaration_to_string(timing))
  }
}

pub fn trigger_load_polling(
  timing_declaration timing: TimingDeclaration,
  filters filters: String,
) {
  attribute(
    "hx-trigger",
    "load every "
      <> timing_declaration_to_string(timing)
      <> " ["
      <> filters
      <> "]",
  )
}

pub fn indicator(css_selector_or_closest css_selector_or_closest: String) {
  attribute("hx-indicator", css_selector_or_closest)
}

pub fn target(extended_css_selector extended_css_selector: ExtendedCssSelector) {
  attribute("hx-target", extended_css_selector_to_string(extended_css_selector))
}

pub fn swap(swap swap: Swap, option option: Option(SwapOption)) {
  case option {
    Some(option) -> {
      swap
      |> swap_to_string
      |> string.append(swap_option_to_string(option))
      |> attribute("hx-swap", _)
    }
    None ->
      swap
      |> swap_to_string
      |> attribute("hx-swap", _)
  }
}
