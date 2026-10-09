import { pageTitle } from 'ember-page-title';
import { LinkTo } from '@ember/routing';
import HelpOverlay from 'seq25/components/help-overlay';

<template>
  {{pageTitle "SEQ25"}}
  <header>
    <h1><LinkTo @route="index">Seq25</LinkTo></h1>
  </header>
  <HelpOverlay />
  {{outlet}}
</template>
