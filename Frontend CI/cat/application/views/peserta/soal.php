<?php
if(!empty($_COOKIE['myJavascriptVar'])){
	$warna = $_COOKIE['myJavascriptVar'];
	$warna = substr($warna,1,strlen($warna)-2);
	$warna = explode(",",$warna);
}else{
	$warna = null;
}
$sesi = $this->session->userdata('data_user');
$id_s = $sesi['sesi_id'];
$this->db->reconnect();
$jumlah = $this->db->query("call get_jumlah_soal_by_sesi('$id_s')")->result_array();
$count_soal = $jumlah[0]['jumlah_soal'];
$soal_id = $this->session->userdata('soal_id');
if (!empty($id)) {
    $idx = $id;
} else {
    $idx = 0;
}

if ($idx < $count_soal) { //INI JANGAN DIILANGI, INI LOGIKA BIAR KALO INDEX LAH SAMO DENGAN TOTAL NILAI BAKAL DIRECT KE HALAMAN HASIL.
    $no_peserta = $this->session->userdata('no_peserta');
    $this->session->set_userdata('idx', $idx);
    $this->db->reconnect();
    $get_jawaban = $this->db->query("call get_jawaban_user('$soal_id[$idx]','$no_peserta')")->result_array();
    $this->db->reconnect();
    $link_gambar = $this->db->query("call is_gambar_exists('$soal_id[$idx]')")->result_array();
    $link = '';
    if (!empty($link_gambar)) {
        $link = $link_gambar[0]['gambar'];
    }
    $jawaban = '';
    if (!empty($get_jawaban)) {
        $jawaban = $get_jawaban[0]['jawaban'];
    }
    $this->db->reconnect();
    if ($idx < $count_soal) {
        $check = $this->db->query("call get_detail_soal('$soal_id[$idx]')")->result_array();
    }
    if (!empty($check)) {
        $pertanyaan = $check[0]['pertanyaan'];
        $opsi_a = $check[0]['opsi_a'];
        $opsi_b = $check[0]['opsi_b'];
        $opsi_c = $check[0]['opsi_c'];
        $opsi_d = $check[0]['opsi_d'];
        $opsi_e = $check[0]['opsi_e'];
    }
?>
    <!DOCTYPE html>
    <html lang="en">

    <head>

        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="">
        <meta name="author" content="">

        <title>Soal Ujian Peserta</title>
        <link rel="shortcut icon" href="<?= base_url() ?>/assets/img/logo.png" />

        <!-- Custom fonts for this template-->
        <link href="<?= base_url('assets/'); ?>vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
        <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">

        <!-- Custom styles for this template-->
        <link href="<?= base_url('assets/'); ?>css/sb-admin-2.min.css" rel="stylesheet">
        <style>
            .solid {
                border-left: 5px #1cc88a solid;
                height: display;
                width: 0px;
                display: inline-block;
                padding-left: 5px;
            }
        </style>

    </head>

    <body class="bg-light">
        <nav class="navbar navbar-light bg-success">
            <img src="<?= base_url() ?>/assets/img/logo.png" width="150px" />
            <span class="navbar-brand mb-0 h1 ml-auto">
                <div class="countdown row text-bold">
                    <div id="jam">NA</div>
                    <p class="mx-1">:</p>
                    <div id="menit">NA</div>
                    <p class="mx-1">:</p>
                    <div id="detik">NA</div>
                </div>
            </span>
        </nav>
        <div class="col-12 row">
            <div class="col-md-2 my-4">
                <h6>Daftar Soal</h6>
                <div class="row">
                    <?php
                    for ($i = 0; $i < $count_soal; $i++) {
                    ?>
                        <form onsubmit="return SubmitJawaban(this);" method="POST" action="<?= base_url('peserta/soal'); ?>">
                            <input type="hidden" name="pilih_soal" value="<?= $i ?>" />
                            <input type="hidden" name="idx" value="<?= $idx ?>" />
                            <input type="hidden" name="jawaban1" class="jawaban1" value="" />
							<?php
								$found = 0;
								if(!empty($warna)){
									foreach($warna as $c){
										if($c===strval($i+1)){
											$found = 1;
											break;
										}
									}
								}
							?>
							<?php
								if($found == 1){
							?>
									<button type="submit" class="btn btn-sm btn-success m-1"><?= $i + 1 ?></button>
                            <?php
								} else{
                            ?>
									<button type="submit" class="btn btn-sm btn-danger m-1"><?= $i + 1 ?></button>
							<?php
								}
                            ?>
                        </form>
                    <?php
                    }
                    ?>
                </div>
            </div>
            <div class="solid"></div>
            <div class="col-9">
                <p class="font-weight-bold mt-3">Soal no <?= $idx + 1 ?></p><br />
                <?php
                if (!empty($link) || $link != "") {
                ?>
                    <img class="mt-1" src="<?= base_url("/assets/img/soal/$link") ?>" alt="Foto Soal" width="300" />
                <?php
                }
                ?>
                <div class="my-2">
                    <p class="h5 text-gray-900"><?= htmlspecialchars_decode($pertanyaan) ?></p>
                </div>
                <div>
                    <form onsubmit="return SubmitJawaban(this);" method="POST" action="<?= base_url('peserta/soal'); ?>">
                        <div>
                            <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                    <div class="input-group-text">
                                        <input type="radio" value="A" <?php echo (strpos($jawaban, 'A') !== false ? 'checked' : ''); ?> name="jawaban" id="A">
                                    </div>
                                </div>
                                <p class="pt-3 mx-2">A. <?= htmlspecialchars_decode($opsi_a) ?></p>
                            </div>
                            <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                    <div class="input-group-text">
                                        <input type="radio" value="B" <?php echo (strpos($jawaban, 'B') !== false ? 'checked' : ''); ?> name="jawaban" id="B">
                                    </div>
                                </div>
                                <p class="pt-3 mx-2">B. <?= htmlspecialchars_decode($opsi_b) ?></p>
                            </div>
                            <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                    <div class="input-group-text">
                                        <input type="radio" value="C" <?php echo (strpos($jawaban, 'C') !== false ? 'checked' : ''); ?> name="jawaban" id="C">
                                    </div>
                                </div>
                                <p class="pt-3 mx-2">C. <?= htmlspecialchars_decode($opsi_c) ?></p>
                            </div>
                            <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                    <div class="input-group-text">
                                        <input type="radio" value="D" <?php echo (strpos($jawaban, 'D') !== false ? 'checked' : ''); ?> name="jawaban" id="D">
                                    </div>
                                </div>
                                <p class="pt-3 mx-2">D. <?= htmlspecialchars_decode($opsi_d) ?></p>
                            </div>
                            <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                    <div class="input-group-text">
                                        <input type="radio" value="E" <?php echo (strpos($jawaban, 'E') !== false ? 'checked' : ''); ?> name="jawaban" id="E">
                                    </div>
                                </div>
                                <p class="pt-3 mx-2">E. <?= htmlspecialchars_decode($opsi_e) ?></p>
                            </div>
                        </div>
                        <div class="text-center mt-5">
                            <?php
                            if ($idx > 0) {
                            ?>
                                <button type="submit" class="btn btn-danger ml-auto" name="pilih_soal" value="<?= $idx - 1 ?>">Soal Sebelumnya</button>
                            <?php
                            }
                            ?>
                            <?php
                            if ($idx < $count_soal - 1) {
                            ?>
                                <button type="submit" class="btn btn-success" name="pilih_soal" value="<?= $idx + 1 ?>">Soal Berikutnya</button>
                            <?php
                            } else {
                            ?>
<!--                                 <button role="button" class="btn btn-success" name="pilih_soal" value="<?= $idx + 1 ?>">Selesai</button> -->
				<button role="button" onclick="return confirm('Apakah anda yakin mengakhiri sesi ujian ?')" class="btn btn-success" name="pilih_soal" value="<?= $idx + 1 ?>">Selesai</button>
                            <?php
                            }
                            ?>
                        </div>

                    </form>
                </div>
            </div>
        </div>
		<!-- SCRIPT UNTUK DAFTAR SOAL-->

		<script>
			function SubmitJawaban(){
				// Check browser support
				var jawaban_p = "";
				var idx=null;
				if(document.getElementById('A').checked){
					jawaban_p = document.getElementById('A').value;
					idx=<?= $idx+1 ?>;
				}else if(document.getElementById('B').checked){
					jawaban_p = document.getElementById('B').value;
					idx=<?= $idx+1 ?>;
				}else if(document.getElementById('C').checked){
					jawaban_p = document.getElementById('C').value;
					idx=<?= $idx+1 ?>;
				}else if(document.getElementById('D').checked){
					jawaban_p = document.getElementById('D').value;
					idx=<?= $idx+1 ?>;
				}else if(document.getElementById('E').checked){
					jawaban_p = document.getElementById('E').value;
					idx=<?= $idx+1 ?>;
				}
				if (typeof(Storage) !== "undefined") {
				// Store
				localStorage.setItem("jawaban_p", jawaban_p);
				// Retrieve
				var elements = document.getElementsByClassName("jawaban1");
				var input = localStorage.getItem("jawaban_p");
				for(var i = 0; i < elements.length; i++) {
					elements[i].value = input;
				}
				} else {
				document.getElementById("jawaban1").value = "";
				}
				if (localStorage.getItem('daftar_jawaban') === null) {
                    daftar_jawaban = [];
                } else {
					if(idx!=null){
						daftar_jawaban = JSON.parse(localStorage.getItem('daftar_jawaban'));
                    }
                }
                daftar_jawaban.push(idx);
                localStorage.setItem('daftar_jawaban', JSON.stringify(daftar_jawaban));
                var str = '';
				document.cookie = str.concat("myJavascriptVar =",localStorage.getItem('daftar_jawaban'));
			}
		</script>

        <!-- COUNTDOWN-->
        <script type="text/javascript">
            var countDate = new Date('<?= print_r($this->session->userdata('sesi')); ?>').getTime();

            function selesai() {
                var now = new Date().getTime();
                gap = countDate - now;

                var detik = 1000;
                var menit = detik * 60;
                var jam = menit * 60;
                var hari = jam * 24;

                var j = Math.floor((gap % (hari)) / (jam));
                var m = Math.floor((gap % (jam)) / (menit));
                var d = Math.floor((gap % (menit)) / (detik));
                if (j < 0 && m < 0 && d < 0) {
                    window.location = "<?= base_url("peserta/hasil") ?>"
                }
                document.getElementById('jam').innerText = j;
                document.getElementById('menit').innerText = m;
                document.getElementById('detik').innerText = d;
            }
            setInterval(function() {
                selesai();
            }, 1000);
        </script>



        <!-- Bootstrap core JavaScript-->
        <script src="<?= base_url('assets/'); ?>vendor/jquery/jquery.min.js"></script>
        <script src="<?= base_url('assets/'); ?>vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

        <!-- Core plugin JavaScript-->
        <script src="<?= base_url('assets/'); ?>vendor/jquery-easing/jquery.easing.min.js"></script>

        <!-- Custom scripts for all pages-->
        <script src="js/sb-admin-2.min.js"></script>

    </body>

    </html>
<?php
} else {
    redirect('peserta/hasil');
}
?>
