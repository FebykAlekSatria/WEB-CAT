<?php
defined('BASEPATH') or exit('No direct script access allowed');

class LiveScore extends CI_Controller
{
	public function index()
	{
		$id = $this->input->post('idKategori');
		$data['id'] = $id;
		$this->load->view('liveScore/liveScore', $data);
	}
	public function detailNilai()
    {
		$this->load->view('liveScore/detailNilai');
    }
}
