// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import ChosenController from "./chosen_controller"
application.register("chosen", ChosenController)


import Flatpickr from "stimulus-flatpickr"

application.register("flatpickr", Flatpickr);
import NestedForm from 'stimulus-rails-nested-form'
application.register('nested-form', NestedForm)
import ClassSearchAutoCompleteController from "./class_search_auto_complete_controller"
application.register("class-search-auto-complete", ClassSearchAutoCompleteController)

import ContainerSplitterController from "./container_splitter_controller"
application.register("container-splitter", ContainerSplitterController)

import FormAutoCompleteController from "./form_auto_complete_controller"
application.register("form-auto-complete", FormAutoCompleteController)

import HistoryController from "./history_controller"
application.register("history", HistoryController)

import LabelAjaxController from "./label_ajax_controller"
application.register("label-ajax", LabelAjaxController)

import LabelsAjaxContainerController from "./labels_ajax_container_controller"
application.register("labels-ajax-container", LabelsAjaxContainerController)

import LoadChartController from "./load_chart_controller"
application.register("load-chart", LoadChartController)

import MetadataDownloaderController from "./metadata_downloader_controller"
application.register("metadata-downloader", MetadataDownloaderController)

import OntoportalAutocompleteController from "./ontoportal_autocomplete_controller"
application.register("ontoportal-autocomplete", OntoportalAutocompleteController)

import ShowModalController from "./show_modal_controller"
application.register("show-modal", ShowModalController)

import SimpleTreeController from "./simple_tree_controller"
application.register("simple-tree", SimpleTreeController)

import SkosCollectionColorsController from "./skos_collection_colors_controller"
application.register("skos-collection-colors", SkosCollectionColorsController)

import SubscribeNotesController from "./subscribe_notes_controller"
application.register("subscribe-notes", SubscribeNotesController)

import TooltipController from "./tooltip_controller"
application.register("tooltip", TooltipController)

import TurboFrameController from "./turbo_frame_controller"
application.register("turbo-frame", TurboFrameController)

import TurboFrameErrorController from "./turbo_frame_error_controller"
application.register("turbo-frame-error", TurboFrameErrorController)
