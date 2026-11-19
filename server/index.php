<?php
  // entrada da url
  $cmd = $_GET['comando'] ?? null;
  $saida = exec('dig "' . $cmd . '" +short');
  echo "IP do dominio ${cmd}: " . $saida . " \n";
?>