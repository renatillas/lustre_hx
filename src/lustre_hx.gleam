import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{attribute}

pub type Timing {
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

pub type SyncOption {
  Default(css_selector: String)
  Drop(css_selector: String)
  Abort(css_selector: String)
  Replace(css_selector: String)
  SyncQueue(css_selector: String, queue: Queue)
}

pub type Scroll {
  Top
  Bottom
}

pub type SwapOption {
  Transition(Bool)
  Swap(Timing)
  Settle(Timing)
  IgnoreTitle(Bool)
  Scroll(Scroll)
  Show(Scroll)
  FocusScroll(Bool)
}

pub type ExtendedCssSelector {
  CssSelector(css_selector: String)
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
}

/// # Event
/// Used by the `trigger` function. 
///
/// A trigger can also have additional modifiers that change its behavior, represented as a `List(EventModifier)`.
pub type Event {
  Event(event: String, modifiers: List(EventModifier))
}

pub type EventModifier {
  Once
  Changed
  Delay(Timing)
  Throttle(Timing)
  From(extended_css_selector: ExtendedCssSelector)
  Target(css_selector: String)
  Consume
  QueueEvent(Option(Queue))
}

fn sync_option_to_string(sync_option: SyncOption) {
  case sync_option {
    Drop(selector) -> selector <> ":drop"
    Abort(selector) -> selector <> ":abort"
    Replace(selector) -> selector <> ":replace"
    SyncQueue(selector, First) -> selector <> ":queue first"
    SyncQueue(selector, All) -> selector <> ":queue all"
    SyncQueue(selector, Last) -> selector <> ":queue last"
    Default(selector) -> selector
  }
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
    CssSelector(css_selector) -> css_selector
    Document -> "document"
    Window -> "window"
    Closest(css_selector) -> "closest " <> css_selector
    Find(css_selector) -> "find " <> css_selector
    Next(css_selector) -> "next " <> option.unwrap(css_selector, "")
    Previous(css_selector) -> "previous " <> option.unwrap(css_selector, "")
    This -> "this"
  }
}

fn queue_to_string(queue: Option(Queue)) -> String {
  case queue {
    Some(First) -> "first"
    Some(Last) -> "last"
    Some(All) -> "all"
    None -> "none"
  }
}

fn timing_declaration_to_string(timing: Timing) {
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
    QueueEvent(queue) -> "queue:" <> queue_to_string(queue)
  }
}

/// # hx-get
/// Issues a GET request to the given URL when the element is triggered.
/// By default, AJAX requests are triggered by the “natural” event of an element:
///
/// * input, textarea & select are triggered on the change event
/// * form is triggered on the submit event
/// * everything else is triggered by the click event
///
/// If you want different behavior you can use the hx-trigger attribute, provided by lustre_hx.trigger, to specify which event will cause the request.
pub fn get(url url: String) {
  attribute("hx-get", url)
}

/// # hx-post
/// Issues a POST request to the given URL when the element is triggered. By default, AJAX requests are triggered by the “natural” event of an element:
///
/// * input, textarea & select are triggered on the change event
/// * form is triggered on the submit event
/// * everything else is triggered by the click event
///
/// If you want different behavior you can use the hx-trigger attribute, provided by lustre_hx.trigger, to specify which event will cause the request.
pub fn post(url url: String) {
  attribute("hx-post", url)
}

/// # hx-put
/// Issues a PUT request to the given URL when the element is triggered. By default, AJAX requests are triggered by the “natural” event of an element:
///
/// * input, textarea & select are triggered on the change event
/// * form is triggered on the submit event
/// * everything else is triggered by the click event
///
/// If you want different behavior you can use the hx-trigger attribute, provided by lustre_hx.trigger, to specify which event will cause the request.
pub fn put(url url: String) {
  attribute("hx-put", url)
}

/// # hx-patch
/// Issues a PATCH request to the given URL when the element is triggered. By default, AJAX requests are triggered by the “natural” event of an element:
///
/// * input, textarea & select are triggered on the change event
/// * form is triggered on the submit event
/// * everything else is triggered by the click event
///
/// If you want different behavior you can use the hx-trigger attribute, provided by lustre_hx.trigger, to specify which event will cause the request.
pub fn patch(url url: String) {
  attribute("hx-patch", url)
}

/// # hx-delete
/// Issues a DELETE request to the given URL when the element is triggered. By default, AJAX requests are triggered by the “natural” event of an element:
///
/// * input, textarea & select are triggered on the change event
/// * form is triggered on the submit event
/// * everything else is triggered by the click event
///
/// If you want different behavior you can use the hx-trigger attribute, provided by lustre_hx.trigger, to specify which event will cause the request.
pub fn delete(url url: String) {
  attribute("hx-delete", url)
}

//
/// # hx-trigger
/// By default, AJAX requests are triggered by the “natural” event of an element:
///
/// * input, textarea & select are triggered on the change event
/// * form is triggered on the submit event
/// * everything else is triggered by the click event
///
/// If you want different behavior you can use the hx-trigger attribute to specify which event will cause the request.
pub fn trigger(events: List(Event)) {
  let events =
    events
    |> list.map(event_to_string)
    |> string.join(", ")
  attribute("hx-trigger", events)
}

pub fn trigger_polling(
  timing_declaration timing: Timing,
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
  timing_declaration timing: Timing,
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

pub fn swap(swap swap: Swap, with_option option: Option(SwapOption)) {
  case option {
    Some(option) -> {
      swap
      |> swap_to_string
      |> string.append(" " <> swap_option_to_string(option))
      |> attribute("hx-swap", _)
    }
    None ->
      swap
      |> swap_to_string
      |> attribute("hx-swap", _)
  }
}

pub fn sync(syncronize_on: List(SyncOption)) {
  attribute(
    "hx-sync",
    list.map(syncronize_on, sync_option_to_string) |> string.join(" "),
  )
}

pub fn select(css_selector: String) {
  attribute("hx-select", css_selector)
}

pub fn push_url(bool: Bool) {
  case bool {
    True -> attribute("hx-push-url", "true")
    False -> attribute("hx-push-url", "false")
  }
}

pub fn confirm(confirm_text: String) {
  attribute("hx-confirm", confirm_text)
}

pub fn boost(set: Bool) {
  case set {
    True -> attribute("hx-boost", "true")
    False -> attribute("hx-boost", "false")
  }
}

pub fn hyper_script(script: String) {
  attribute("_", script)
}
