<?php
defined('BASEPATH') or exit('No direct script access allowed');
class ImportController extends CI_Controller
{
	public function __construct()
	{
		parent::__construct();
		$this->load->file(APPPATH . 'libraries/PHPExcel.php');
		$this->load->helper(array('form', 'url'));
	}

	public function index()
	{
		$this->load->model('ImportModel');
		$data = array(
			'list_data'	=> $this->ImportModel->getData()
		);
		$this->load->view('import_excel.php', $data);
	}
	public function import_excel_soal()
	{
		$this->form_validation->set_rules('fileExcel', 'FileExcel', 'required');
		if ($this->form_validation->run() == false) {
			$this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
			Soal gagal ditambahkan
			</div>');
			redirect('admin/peserta');
		} else {
			if (isset($_FILES["fileExcel"]["name"])) {
				$path = $_FILES["fileExcel"]["tmp_name"];
				$objReader = new PHPExcel_Reader_Excel2007();
				$object = $objReader->load($path);
				foreach ($object->getWorksheetIterator() as $worksheet) {
					$highestRow = $worksheet->getHighestRow();
					$highestColumn = $worksheet->getHighestColumn();
					for ($row = 2; $row <= $highestRow; $row++) {
						$kategori = addslashes($worksheet->getCellByColumnAndRow(0, $row)->getValue());
						$soal = addslashes($worksheet->getCellByColumnAndRow(1, $row)->getValue());
						$temp_data[] = array(
							'id' => uniqid(), //Butuh id ?
							'kategori'	=> $kategori,
							'soal'	=> $soal
						);
					}
				}
				$this->load->model('ImportModel');
				$insert = $this->ImportModel->insert_soal($temp_data);
				$this->session->set_flashdata('message', '<div class="alert alert-success" role="alert">
			Soal berhasil ditambahkan
			</div>');
				if ($insert) {
					redirect('admin/peserta');
				} else {
					$this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
			Soal gagal ditambahkan
			</div>');
					redirect('admin/peserta');
				}
			}
		}
	}
	public function add_peserta()
	{
		$this->form_validation->set_rules('fullName', 'FullName', 'trim|required');
		$this->form_validation->set_rules('username', 'Username', 'trim|required');
		$this->form_validation->set_rules('noHandphone', 'NoHandphone', 'trim|required');
		$this->form_validation->set_rules('asal', 'Asal', 'trim|required');
		$this->form_validation->set_rules('password', 'Password', 'trim|required');
		if ($this->form_validation->run() == false) {
			$this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
			Data peserta tidak boleh kosong
			</div>');
			redirect($_SERVER['HTTP_REFERER']);
		} else {
			$name = $this->input->post('fullName');
			$username = $this->input->post('username');
			$no_hp = $this->input->post('noHandphone');
			$asal = $this->input->post('asal');
			$password = $this->input->post('password');
			$id = uniqid();
			$username_check = $this->db->query("call is_username_exists('$username')")->result_array();
			if ($username_check[0]['RESULT'] == '0') {
				$this->db->reconnect();
				$cek = $this->db->query("call add_peserta('$id','$username','$password','$name','$asal','$no_hp')");
				$this->session->set_flashdata('message', '<div class="alert alert-success" role="alert">
			Peserta berhasil ditambah
			</div>');
				redirect($_SERVER['HTTP_REFERER']);
			} else {
				$this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
			Username sudah terdaftar
			</div>');
				redirect($_SERVER['HTTP_REFERER']);
			}
		}
	}
	public function add_peserta_sesi()
	{
		$this->form_validation->set_rules('fullName', 'FullName', 'trim|required');
		$this->form_validation->set_rules('username', 'Username', 'trim|required');
		$this->form_validation->set_rules('noHandphone', 'NoHandphone', 'trim|required');
		$this->form_validation->set_rules('asal', 'Asal', 'trim|required');
		$this->form_validation->set_rules('password', 'Password', 'trim|required');
		if ($this->form_validation->run() == false) {
			$this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
			Data tidak boleh kosong
			</div>');
			redirect($_SERVER['HTTP_REFERER']);
		} else {
			$name = $this->input->post('fullName');
			$username = $this->input->post('username');
			$no_hp = $this->input->post('noHandphone');
			$asal = $this->input->post('asal');
			$password = $this->input->post('password');
			$id = uniqid();
			$username_check = $this->db->query("call is_username_exists('$username')")->result_array();
			if ($username_check[0]['RESULT'] == '0') {
				$this->db->reconnect();
				$cek = $this->db->query("call add_peserta('$id','$username','$password','$name','$asal','$no_hp')");
				$this->session->set_flashdata('message', '<div class="alert alert-success" role="alert">
			Peserta berhasil ditambah
			</div>');
				redirect($_SERVER['HTTP_REFERER']);
			} else {
				$this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
			Username sudah terdaftar
			</div>');
				redirect($_SERVER['HTTP_REFERER']);
			}
		}
	}
	public function add_peserta_to_ujian()
	{
		$id_s = $this->input->post('id');
		$peserta_id = $this->db->query("call get_peserta_ujian_list_by_sesi('$id_s')")->result_array();
		$list_id = $this->input->post('pilih');
		if (!empty($list_id)) {
			foreach ($list_id as $value) {
				$check = 0;
				if (!empty($peserta_id)) {
					foreach ($peserta_id as $peserta) {
						if ($value == $peserta['peserta_id']) {
							$check = 1;
							echo $check;
							break;
						}
					}
				}
				if ($check == 0) {
					$number = uniqid();
					$varray = str_split($number);
					$len = sizeof($varray);
					$no_peserta = array_slice($varray, $len - 5, $len);
					$no_peserta = implode(",", $no_peserta);
					$no_peserta = str_replace(',', '', $no_peserta);
					$this->db->reconnect();
					$cek = $this->db->query("call add_peserta_to_ujian('$no_peserta','$value','$id_s')");
				}
			}
			$this->session->set_flashdata('message', '<div class="alert alert-success" role="alert">
			Peserta berhasil ditambah ke sesi
			</div>');
			redirect('admin/jadwal');
		} else {
			$this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
			Peserta gagal ditambah ke sesi
			</div>');
			redirect('admin/jadwal');
			//redirect kemano kalo gagal
		}
	}
	public function excel_peserta_to_sesi()
	{
		$this->form_validation->set_rules('PIN', 'Pin', 'trim|required');
		if ($this->form_validation->run() == false) {
			$this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
			PIN tidak boleh kosong
			</div>');
			redirect($_SERVER['HTTP_REFERER']);
		} else {
			$pin_sesi = $this->input->post('PIN');

			$cek = $this->db->query("call is_kode_sesi_exists('$pin_sesi')")->result_array();
			if ($cek[0]['RESULT'] == '1') {
				if (isset($_FILES["fileExcel"]["name"])) {

					$file_tmp = $_FILES['fileExcel']['tmp_name'];
					$file_name = $_FILES['fileExcel']['name'];
					$file_size = $_FILES['fileExcel']['size'];
					$file_type = $_FILES['fileExcel']['type'];

					$object = PHPExcel_IOFactory::load($file_tmp);
					foreach ($object->getWorksheetIterator() as $worksheet) {

						$highestRow = $worksheet->getHighestRow();
						$highestColumn = $worksheet->getHighestColumn();

						for ($row = 2; $row <= $highestRow; $row++) {
							$number = uniqid();
							$varray = str_split($number);
							$len = sizeof($varray);
							$no_peserta = array_slice($varray, $len - 5, $len);
							$no_peserta = implode(",", $no_peserta);
							$no_peserta = str_replace(',', '', $no_peserta);
							$nama = $worksheet->getCellByColumnAndRow(0, $row)->getValue();
							$username = $worksheet->getCellByColumnAndRow(1, $row)->getValue();
							$password = $worksheet->getCellByColumnAndRow(2, $row)->getValue();
							$no_hp = $worksheet->getCellByColumnAndRow(3, $row)->getValue();
							$asal_sekolah = $worksheet->getCellByColumnAndRow(4, $row)->getValue();
							$temp_data[] = array(
								'pin_sesi' => $pin_sesi,
								'nama' => $nama,
								'username'	=> $username,
								'password'	=> $password,
								'no_hp'	=> $no_hp,
								'asal'	=> $asal_sekolah,
								'no_peserta' => $no_peserta,
								'user_id' => uniqid()
							);
						}
					}
					$this->load->model('ImportModel');
					$insert = $this->ImportModel->insert_peserta_to_sesi($temp_data);

					// $this->db->insert_batch('mahasiswa', $data);

					//echo "berhasil";
					//print_r($temp_data);
					//$id = $temp_data[0]['id'];
					//echo "call add_peserta('$id','$username','$password','$nama','$asal','$hp')";
				}
				if ($insert) {
					$this->session->set_flashdata('message', '<div class="alert alert-success" role="alert">
				Peserta berhasil ditambahkan kedalam sesi
				</div>');
					redirect('admin/jadwal');
				} else {
					$this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
				Peserta gagal ditambahkan kedalam sesi
				</div>');
					redirect('admin/jadwal');
				}
			} else {
				$this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
				Pin sesi belum terdaftar
				</div>');
				redirect('admin/jadwal');
			}
		}
	}
	public function delete_peserta_sesi()
	{
		$id = $this->input->get('id');
		$cek = $this->db->query("call delete_peserta_from_ujian('$id')");
		redirect($_SERVER['HTTP_REFERER']);
	}
	public function delete_peserta()
	{
		$id = $this->input->get('id');
		$cek = $this->db->query("call delete_peserta('$id')");
		redirect('admin/peserta');
	}
	public function edit_peserta()
	{
		$this->form_validation->set_rules('fullName', 'FullName', 'trim|required');
		$this->form_validation->set_rules('noHandphone', 'NoHandphone', 'trim|required');
		$this->form_validation->set_rules('asal', 'Asal', 'trim|required');
		if ($this->form_validation->run() == false) {
			redirect('admin/peserta');
		} else {
			$id = $this->input->post('id');
			$name = $this->input->post('fullName');
			$no_hp = $this->input->post('noHandphone');
			$asal = $this->input->post('asal');
			$password = $this->input->post('password');
			if ($password == "") {
				$cek = $this->db->query("call edit_peserta('$id',null,'$name','$asal','$no_hp')");
			} else {
				$cek = $this->db->query("call edit_peserta('$id','$password','$name','$asal','$no_hp')");
			}
			redirect('admin/peserta');
		}
	}
	public function edit_kategori() //fungsi baru
	{
		$this->form_validation->set_rules('name', 'Name', 'trim|required');
		$this->form_validation->set_rules('nilai', 'Nilai', 'trim|required');
		if ($this->form_validation->run() == false) {
			redirect('admin/peserta');
		} else {
			$id = $this->input->post('id');
			$name = $this->input->post('name');
			$nilai = $this->input->post('nilai');
			$cek = $this->db->query("call edit_kategori('$id','$name','$nilai')");
			redirect('admin/kategori');
		}
	}
	public function add_kategori()
	{
		$this->form_validation->set_rules('name', 'Name', 'trim|required');
		$this->form_validation->set_rules('nilai', 'Nilai', 'trim|required');
		if ($this->form_validation->run() == false) {
			$this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
			Nama dan nilai kategori tidak boleh kosong
			</div>');
			redirect($_SERVER['HTTP_REFERER']);
		} else {
			$id = uniqid();
			$name = $this->input->post('name');
			$nilai = $this->input->post('nilai');
			$cek = $this->db->query("call add_kategori('$id','$name',$nilai)");
			$this->session->set_flashdata('message', '<div class="alert alert-success" role="alert">
			Kategori berhasil ditambahkan
			</div>');
			redirect($_SERVER['HTTP_REFERER']);
		}
	}
	public function delete_kategori()
	{ {
			$id = $this->input->get('id');
			$cek = $this->db->query("call delete_kategori('$id')");
			redirect('admin/kategori');
		}
	}
	public function add_soal()
	{
		$this->form_validation->set_rules('kategori', 'Kategori', 'trim|required');
		$this->form_validation->set_rules('opsi_a', 'Opsi_a', 'trim|required');
		$this->form_validation->set_rules('opsi_b', 'Opsi_b', 'trim|required');
		$this->form_validation->set_rules('opsi_c', 'Opsi_c', 'trim|required');
		$this->form_validation->set_rules('opsi_d', 'Opsi_d', 'trim|required');
		$this->form_validation->set_rules('opsi_e', 'Opsi_e', 'trim|required');
		$this->form_validation->set_rules('soal', 'Soal', 'trim|required');
		if ($this->form_validation->run() == false) {
			echo $this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
            Soal dan Opsi jawaban tidak boleh kosong
            </div>');
			redirect($_SERVER['HTTP_REFERER']);
		} else {
			$id_s = uniqid();
			$kategori = $this->input->post('kategori');
			$soal = htmlspecialchars($this->input->post('soal'));
			$opsi_a = htmlspecialchars($this->input->post('opsi_a'));
			$opsi_b = htmlspecialchars($this->input->post('opsi_b'));
			$opsi_c = htmlspecialchars($this->input->post('opsi_c'));
			$opsi_d = htmlspecialchars($this->input->post('opsi_d'));
			$opsi_e = htmlspecialchars($this->input->post('opsi_e'));
			$jawaban = $this->input->post('jawaban');
			$jawaban1 = "";
			if (!empty($jawaban)) {
				foreach ($jawaban as $value) {
					$jawaban1 = $jawaban1 . $value . " ";
				}
			}
			//awal logika penentuan bobot a
			if (!empty($this->input->post('bobot_a')) && ((strpos($jawaban1, 'A') !== false))) {
				$bobot_a = htmlspecialchars($this->input->post('bobot_a'));
			} else {
				$bobot_a = "0";
			}
			if ($this->input->post('bobot_a') == "" && ((strpos($jawaban1, 'A') !== false))) {
				$bobot_a = "1";
			}
			//akhir logika penentuan bobot a
			//awal logika penentuan bobot b
			if (!empty($this->input->post('bobot_b')) && ((strpos($jawaban1, 'B') !== false))) {
				$bobot_b = htmlspecialchars($this->input->post('bobot_b'));
			} else {
				$bobot_b = "0";
			}
			if ($this->input->post('bobot_b') == "" && ((strpos($jawaban1, 'B') !== false))) {
				$bobot_b = "1";
			}
			//akhir logika penentuan bobot b
			//awal logika penentuan bobot c
			if (!empty($this->input->post('bobot_c')) && ((strpos($jawaban1, 'C') !== false))) {
				$bobot_c = htmlspecialchars($this->input->post('bobot_c'));
			} else {
				$bobot_c = "0";
			}
			if ($this->input->post('bobot_c') == "" && ((strpos($jawaban1, 'C') !== false))) {
				$bobot_c = "1";
			}
			//akhir logika penentuan bobot c
			//awal logika penentuan bobot d
			if (!empty($this->input->post('bobot_d')) && ((strpos($jawaban1, 'D') !== false))) {
				$bobot_d = htmlspecialchars($this->input->post('bobot_d'));
			} else {
				$bobot_d = "0";
			}
			if ($this->input->post('bobot_d') == "" && ((strpos($jawaban1, 'D') !== false))) {
				$bobot_d = "1";
			}
			//akhir logika penentuan bobot d
			//awal logika penentuan bobot e
			if (!empty($this->input->post('bobot_e')) && ((strpos($jawaban1, 'E') !== false))) {
				$bobot_e = htmlspecialchars($this->input->post('bobot_e'));
			} else {
				$bobot_e = "0";
			}
			if ($this->input->post('bobot_e') == "" && ((strpos($jawaban1, 'E') !== false))) {
				$bobot_e = "1";
			}
			//akhir logika penentuan bobot e
			//ini porses upload gambar
			$config['upload_path']          = APPPATH . '../assets/img/soal/';
			$config['allowed_types']        = 'gif|jpg|png';
			//$config['max_size']             = 100;
			//$config['max_width']            = 1024;
			//$config['max_height']           = 768;
			if (!file_exists($config['upload_path'])) {
				mkdir($config['upload_path'], 0777, true);
			}
			$this->load->library('upload', $config);
			echo $this->input->post('foto');
			if (!$this->upload->do_upload('foto')) {
				$error = array('error' => $this->upload->display_errors());
				$cek = $this->db->query("call add_soal('$id_s','$kategori','$soal',null,'$opsi_a','$opsi_b','$opsi_c','$opsi_d','$opsi_e','$jawaban1','$bobot_a','$bobot_b','$bobot_c','$bobot_d','$bobot_e')"); //sudah fix bisa
				$this->session->set_flashdata('message', '<div class="alert alert-success" role="alert">
				 Soal berhasil ditambah
				 </div>');
				redirect('admin/soal');
				//$this->load->view('v_upload', $error);
			} else {
				$data = array('upload_data' => $this->upload->data());
				$foto = $data['upload_data']['file_name'];
				$cek = $this->db->query("call add_soal('$id_s','$kategori','$soal','$foto','$opsi_a','$opsi_b','$opsi_c','$opsi_d','$opsi_e','$jawaban1','$bobot_a','$bobot_b','$bobot_c','$bobot_d','$bobot_e')");
				//sudah fix bisa
				$this->session->set_flashdata('message', '<div class="alert alert-success" role="alert">
				 Soal berhasil ditambah
				 </div>');
				redirect('admin/soal');
				//$this->load->view('v_upload_sukses', $data);
			}
		}
	}
	public function edit_soal() //baru
	{
		$this->form_validation->set_rules('kategori', 'Kategori', 'trim|required');
		$this->form_validation->set_rules('opsi_a', 'Opsi_a', 'trim|required');
		$this->form_validation->set_rules('opsi_b', 'Opsi_b', 'trim|required');
		$this->form_validation->set_rules('opsi_c', 'Opsi_c', 'trim|required');
		$this->form_validation->set_rules('opsi_d', 'Opsi_d', 'trim|required');
		$this->form_validation->set_rules('opsi_e', 'Opsi_e', 'trim|required');
		$this->form_validation->set_rules('soal', 'Soal', 'trim|required');
		if ($this->form_validation->run() == false) {
			echo $this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
            Soal dan Opsi jawaban tidak boleh kosong
            </div>');
			redirect($_SERVER['HTTP_REFERER']);
		} else {
			$id_s = $this->input->post('id');
			$kategori = $this->input->post('kategori');
			$soal = htmlspecialchars($this->input->post('soal'));
			$opsi_a = htmlspecialchars($this->input->post('opsi_a'));
			$opsi_b = htmlspecialchars($this->input->post('opsi_b'));
			$opsi_c = htmlspecialchars($this->input->post('opsi_c'));
			$opsi_d = htmlspecialchars($this->input->post('opsi_d'));
			$opsi_e = htmlspecialchars($this->input->post('opsi_e'));
			$jawaban = $this->input->post('jawaban');
			$jawaban1 = "";
			if (!empty($jawaban)) {
				foreach ($jawaban as $value) {
					$jawaban1 = $jawaban1 . $value . " ";
				}
			}
			//awal logika penentuan bobot a
			if (!empty($this->input->post('bobot_a')) && ((strpos($jawaban1, 'A') !== false))) {
				$bobot_a = htmlspecialchars($this->input->post('bobot_a'));
			} else {
				$bobot_a = "0";
			}
			if ($this->input->post('bobot_a') == "" && ((strpos($jawaban1, 'A') !== false))) {
				$bobot_a = "1";
			}
			//akhir logika penentuan bobot a
			//awal logika penentuan bobot b
			if (!empty($this->input->post('bobot_b')) && ((strpos($jawaban1, 'B') !== false))) {
				$bobot_b = htmlspecialchars($this->input->post('bobot_b'));
			} else {
				$bobot_b = "0";
			}
			if ($this->input->post('bobot_b') == "" && ((strpos($jawaban1, 'B') !== false))) {
				$bobot_b = "1";
			}
			//akhir logika penentuan bobot b
			//awal logika penentuan bobot c
			if (!empty($this->input->post('bobot_c')) && ((strpos($jawaban1, 'C') !== false))) {
				$bobot_c = htmlspecialchars($this->input->post('bobot_c'));
			} else {
				$bobot_c = "0";
			}
			if ($this->input->post('bobot_c') == "" && ((strpos($jawaban1, 'C') !== false))) {
				$bobot_c = "1";
			}
			//akhir logika penentuan bobot c
			//awal logika penentuan bobot d
			if (!empty($this->input->post('bobot_d')) && ((strpos($jawaban1, 'D') !== false))) {
				$bobot_d = htmlspecialchars($this->input->post('bobot_d'));
			} else {
				$bobot_d = "0";
			}
			if ($this->input->post('bobot_d') == "" && ((strpos($jawaban1, 'D') !== false))) {
				$bobot_d = "1";
			}
			//akhir logika penentuan bobot d
			//awal logika penentuan bobot e
			if (!empty($this->input->post('bobot_e')) && ((strpos($jawaban1, 'E') !== false))) {
				$bobot_e = htmlspecialchars($this->input->post('bobot_e'));
			} else {
				$bobot_e = "0";
			}
			if ($this->input->post('bobot_e') == "" && ((strpos($jawaban1, 'E') !== false))) {
				$bobot_e = "1";
			}
			//akhir logika penentuan bobot e

			//porses upload gambar
			$config['upload_path']          = APPPATH . 'upload/gambar/';
			$config['allowed_types']        = 'gif|jpg|png';
			//$config['max_size']             = 100;
			//$config['max_width']            = 1024;
			//$config['max_height']           = 768;
			if (!file_exists($config['upload_path'])) {
				mkdir($config['upload_path'], 0777, true);
			}
			$this->load->library('upload', $config);
			echo $this->input->post('foto');
			if (!$this->upload->do_upload('foto')) {
				$error = array('error' => $this->upload->display_errors());
				$foto = "";
				$cek = $this->db->query("call edit_soal('$id_s','$kategori','$soal',null,'$opsi_a','$opsi_b','$opsi_c','$opsi_d','$opsi_e','$jawaban1','$bobot_a','$bobot_b','$bobot_c','$bobot_d','$bobot_e')"); //sudah fix bisa
				echo $this->session->set_flashdata('message', '<div class="alert alert-success" role="alert">
				 Soal berhasil diedit
				 </div>');
				redirect('admin/soal');
				//$this->load->view('v_upload', $error);
			} else {
				$data = array('upload_data' => $this->upload->data());
				$foto = $data['upload_data']['full_path'];
				$cek = $this->db->query("call edit_soal('$id_s','$kategori','$soal','$foto','$opsi_a','$opsi_b','$opsi_c','$opsi_d','$opsi_e','$jawaban1','$bobot_a','$bobot_b','$bobot_c','$bobot_d','$bobot_e')"); //sudah fix bisa
				echo $this->session->set_flashdata('message', '<div class="alert alert-success" role="alert">
				 Soal berhasil diedit
				 </div>');
				redirect('admin/soal');
				//$this->load->view('v_upload_sukses', $data);
			}
		}
	}
	public function delete_soal()
	{
		$id = $this->input->get('id');
		$cek = $this->db->query("call delete_soal('$id')");
		redirect('admin/soal');
	}
	public function add_sesi() //baru
	{
		$this->form_validation->set_rules('name', 'Name', 'trim|required');
		$this->form_validation->set_rules('address', 'Addres', 'trim|required');
		$this->form_validation->set_rules('time', 'Time', 'trim|required');
		$this->form_validation->set_rules('date', 'Date', 'trim|required');
		$this->form_validation->set_rules('durasi', 'Durasi', 'trim|required');
		$this->form_validation->set_rules('score', 'Score', 'trim|required');
		if ($this->form_validation->run() == false) {
			$this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
			Data tidak boleh kosong
			</div>');
			redirect($_SERVER['HTTP_REFERER']);
		} else {
			$id_sesi = uniqid();
			$nama_ujian = $this->input->post('name');
			$tempat = $this->input->post('address');
			$waktu_mulai = $this->input->post('time');
			$tanggal = $this->input->post('date');
			$durasi = $this->input->post('durasi');
			$score = $this->input->post('score');

			$number = uniqid();
			$varray = str_split($number);
			$len = sizeof($varray);
			$kode_sesi = array_slice($varray, $len - 5, $len);
			$kode_sesi = implode(",", $kode_sesi);
			$kode_sesi = str_replace(',', '', $kode_sesi);

			$cek = $this->db->query("call add_sesi('$id_sesi','$nama_ujian','$tempat','$tanggal.$waktu_mulai','$durasi','$score','$kode_sesi')"); //sesuaikan parameter
			$this->session->set_flashdata('message', '<div class="alert alert-success" role="alert">
			Jadwal berhasil ditambahkan
			</div>');
			redirect('admin/jadwal');
		}
	}
	public function edit_sesi() //baru
	{
		$this->form_validation->set_rules('name', 'Name', 'trim|required');
		$this->form_validation->set_rules('address', 'Addres', 'trim|required');
		$this->form_validation->set_rules('time', 'Time', 'trim|required');
		$this->form_validation->set_rules('date', 'Date', 'trim|required');
		$this->form_validation->set_rules('durasi', 'Durasi', 'trim|required');
		$this->form_validation->set_rules('score', 'Score', 'trim|required');
		if ($this->form_validation->run() == false) {
			$this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
			Data tidak boleh kosong
			</div>');
			redirect($_SERVER['HTTP_REFERER']);
		} else {
			$id_sesi = $this->input->post('id');
			$nama_ujian = $this->input->post('name');
			$tempat = $this->input->post('address');
			$waktu_mulai = $this->input->post('time');
			$tanggal = $this->input->post('date');
			$durasi = $this->input->post('durasi');
			$score = $this->input->post('score');

			$cek = $this->db->query("call edit_sesi('$id_sesi','$nama_ujian','$tempat','$tanggal.$waktu_mulai','$durasi','$score')"); //sesuaikan parameter
			$this->session->set_flashdata('message', '<div class="alert alert-success" role="alert">
			Jadwal berhasil diedit
			</div>');
			redirect('admin/jadwal');
		}
	}
	public function delete_sesi()
	{ {
			$id = $this->input->get('id');
			$cek = $this->db->query("call delete_sesi('$id')");
			redirect('admin/jadwal');
		}
	}
	public function pilih_soal() //baru
	{
		$id_s = $this->input->post('id_sesi');
		$nama_k = $this->input->post('nama_k');
		$id_k = array();
		$jumlah = array();
		$urutan = array();
		$i = 0;
		$j = 0;
		$k = 0;
		if (!empty($this->input->post('pilihSoal'))) {
			foreach ($this->input->post('pilihSoal') as $check) {
				$id_k[$i] = $check;
				$i++;
			}
			foreach ($this->input->post('jumlah') as $check) {
				if (!empty($check)) {
					$jumlah[$j] = $check;
					$j++;
				}
			}
			foreach ($this->input->post('urutan') as $check) {
				if (!empty($check)) {
					$urutan[$k] = $check;
					$k++;
				}
			}
		}
		$gagal = array();
		$z = 0;
		for ($l = 0; $l < count($this->input->post('pilihSoal')); $l++) {
			$this->db->reconnect();
			$check = $this->db->query("call count_jumlah_soal_by_kategori('$id_k[$l]')")->result_array();
			if ($check[0]['jumlah_soal'] < $jumlah[$l]) {
				//echo "yang di db lebih kecil";
				$gagal[$z++] = $nama_k[$l];
				$this->session->set_flashdata('message', '<div class="alert alert-danger" role="alert">
		Kategori gagal ditambahkan <?php print_r($gagal)?>
		</div>');
			} else {
				$this->db->reconnect();
				$result = $this->db->query("call add_soal_to_sesi('$id_s','$id_k[$l]','$jumlah[$l]','$urutan[$l]')");
				$this->session->set_flashdata('message', '<div class="alert alert-success" role="alert">
			Kategori berhasil ditambahkan
			</div>');
			}
		}
		if (empty($gagal)) {
			redirect('admin/jadwal');
		} else {
			redirect($_SERVER['HTTP_REFERER']);
		}
	}
	public function delete_soal_from_sesi()
	{
		$id = $this->input->get('id');
		$id_s = substr($id, 0, 13);
		$id_k = substr($id, 13, 13);
		$result = $this->db->query("call delete_soal_from_sesi('$id_s','$id_k')");
		// redirect('admin/jadwal');
		redirect($_SERVER['HTTP_REFERER']);
	}
	public function nilai()
	{
		// if ($this->input->post('submit')) {
		$id = $this->input->post('idKategori');
		echo $id;
		echo "oyyyy";
		// $data['nilai'] = $this->db->query("call get_total_nilai_list('$id')");
	}
	public function tampil_soal()
	{
		$idx = $this->input->post('idx');
		echo $idx;
	}
	public function coba()
	{
		echo $this->input->post('coba');
	}
	public function excel_peserta()
	{
		if (isset($_FILES["fileExcel"]["name"])) {
			// upload
			$file_tmp = $_FILES['fileExcel']['tmp_name'];
			$file_name = $_FILES['fileExcel']['name'];
			$file_size = $_FILES['fileExcel']['size'];
			$file_type = $_FILES['fileExcel']['type'];
			// move_uploaded_file($file_tmp,"uploads/".$file_name); // simpan filenya di folder uploads
			//             echo $file_name;
			//             echo $file_size;
			$object = PHPExcel_IOFactory::load($file_tmp);
			foreach ($object->getWorksheetIterator() as $worksheet) {

				$highestRow = $worksheet->getHighestRow();
				$highestColumn = $worksheet->getHighestColumn();

				for ($row = 2; $row <= $highestRow; $row++) {
					$nama = $worksheet->getCellByColumnAndRow(0, $row)->getValue();
					$username = $worksheet->getCellByColumnAndRow(1, $row)->getValue();
					$password = $worksheet->getCellByColumnAndRow(2, $row)->getValue();
					$hp = $worksheet->getCellByColumnAndRow(3, $row)->getValue();
					$asal = $worksheet->getCellByColumnAndRow(4, $row)->getValue();
					$temp_data[] = array(
						'id' => uniqid(),
						'username'	=> $username,
						'password'	=> $password,
						'nama'	=> $nama,
						'asal'	=> $asal,
						'no_hp'	=> $hp
					);
				}
			}
			$this->load->model('ImportModel');
			$insert = $this->ImportModel->insert_peserta($temp_data);

			// $this->db->insert_batch('mahasiswa', $data);

			//echo "berhasil";
			//print_r($temp_data);
			//$id = $temp_data[0]['id'];
			//echo "call add_peserta('$id','$username','$password','$nama','$asal','$hp')";
		}
		if ($insert) {
			$this->session->set_flashdata('status', '<span class="glyphicon glyphicon-ok"></span> Data Berhasil di Import ke Database');
			redirect('admin/peserta');
		} else {
			$this->session->set_flashdata('status', '<span class="glyphicon glyphicon-remove"></span> Terjadi Kesalahan');
			redirect('admin/peserta');
		}
	}
	public function excel_soal()
	{
		if (isset($_FILES["fileExcel"]["name"])) {
			// upload
			$file_tmp = $_FILES['fileExcel']['tmp_name'];
			$file_name = $_FILES['fileExcel']['name'];
			$file_size = $_FILES['fileExcel']['size'];
			$file_type = $_FILES['fileExcel']['type'];
			// move_uploaded_file($file_tmp,"uploads/".$file_name); // simpan filenya di folder uploads
			//             echo $file_name;
			//             echo $file_size;
			$object = PHPExcel_IOFactory::load($file_tmp);
			foreach ($object->getWorksheetIterator() as $worksheet) {

				$highestRow = $worksheet->getHighestRow();
				$highestColumn = $worksheet->getHighestColumn();

				for ($row = 2; $row <= $highestRow; $row++) {
					$kategori = $worksheet->getCellByColumnAndRow(0, $row)->getValue();
					$soal = $worksheet->getCellByColumnAndRow(1, $row)->getValue();
					$opsi_a = $worksheet->getCellByColumnAndRow(2, $row)->getValue();
					$opsi_b = $worksheet->getCellByColumnAndRow(3, $row)->getValue();
					$opsi_c = $worksheet->getCellByColumnAndRow(4, $row)->getValue();
					$opsi_d = $worksheet->getCellByColumnAndRow(5, $row)->getValue();
					$opsi_e = $worksheet->getCellByColumnAndRow(6, $row)->getValue();
					$bobot_a = $worksheet->getCellByColumnAndRow(7, $row)->getValue();
					$bobot_b = $worksheet->getCellByColumnAndRow(8, $row)->getValue();
					$bobot_c = $worksheet->getCellByColumnAndRow(9, $row)->getValue();
					$bobot_d = $worksheet->getCellByColumnAndRow(10, $row)->getValue();
					$bobot_e = $worksheet->getCellByColumnAndRow(11, $row)->getValue();
					$kunci = $worksheet->getCellByColumnAndRow(12, $row)->getValue();
					$temp_data[] = array(
						'id_s' => uniqid(),
						'kategori'	=> $kategori,
						'soal'	=> $soal,
						'gambar'	=> '',
						'opsi_a'	=> $opsi_a,
						'opsi_b'	=> $opsi_b,
						'opsi_c'	=> $opsi_c,
						'opsi_d'	=> $opsi_d,
						'opsi_e'	=> $opsi_e,
						'bobot_a'	=> $bobot_a,
						'bobot_b'	=> $bobot_b,
						'bobot_c'	=> $bobot_c,
						'bobot_d'	=> $bobot_d,
						'bobot_e'	=> $bobot_e,
						'kunci'	=> $kunci
					);
				}
			}
			$this->load->model('ImportModel');
			$insert = $this->ImportModel->insert_soal($temp_data);

			// $this->db->insert_batch('mahasiswa', $data);

			//echo "berhasil";
			//print_r($temp_data);
			//$id = $temp_data[0]['id'];
			//echo "call add_peserta('$id','$username','$password','$nama','$asal','$hp')";
		}
		if ($insert) {
			$this->session->set_flashdata('status', '<span class="glyphicon glyphicon-ok"></span> Data Berhasil di tambahkan');
			redirect('admin/soal');
		} else {
			$this->session->set_flashdata('status', '<span class="glyphicon glyphicon-remove"></span> Terjadi Kesalahan');
			redirect('admin/soal');
		}
	}
}
