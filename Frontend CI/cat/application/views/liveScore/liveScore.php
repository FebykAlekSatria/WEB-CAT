<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Nilai Peserta</title>
    <link rel="shortcut icon" href="<?= base_url() ?>/assets/img/logo.png" />

    <!-- Custom fonts for this template-->
    <link href="<?= base_url('assets/'); ?>vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="<?= base_url('assets/'); ?>css/sb-admin-2.min.css" rel="stylesheet">

</head>

<body class="bg-light">


    <!-- Outer Row -->
    <div class="row justify-content-center">
        <div class="col-xl-12 col-lg-12 col-md-12">
            <div class="card o-hidden border-0 shadow-md">
                <div class="card-body p-0">
                    <div class="row justify-content-center">
                        <div class="col-lg-10">
                            <div class="">
                                <div class="text-center pt-3">
                                    <img src="<?= base_url() ?>/assets/img/logo.png" width="300px" />
                                    <h1 class="h4 text-gray-900 mb-4 font-weight-bold">Nilai Peserta Ujian</h1>
                                </div>
                                <form class="ml-3" action="<?= base_url('LiveScore'); ?>" method="POST">
                                    <select class="custom-select col-2" id="idKategori" name="idKategori">
                                        <option selected>Pilih Sesi Ujian</option>
                                        <?php $result = $this->db->query('call get_sesi_list()');
                                        foreach ($result->result_array() as $row) {
                                        ?>
                                            <option id=" idKategori" name="idKatgori" value="<?= $row['id'] ?>"><?= $row['nama_ujian'] ?></option>
                                        <?php } ?>
                                    </select>
                                    <button class="btn btn-primary" type="submit">Pilih</button>
                                </form>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive table-wrapper-scroll-y my-custom-scrollbar">
                                    <?php
                                    if (!empty($id)) {
                                    ?>
                                        <table class="table table-bordered table-striped text-center" id="score" cellspacing="0">
                                            <thead>
                                                <tr>
                                                    <th class="col-1">No</th>
                                                    <th>Nama</th>
                                                    <th>Asal Sekolah</th>
                                                    <th>No Handphone</th>
                                                    <th>Total Nilai</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <?php
                                                $no = 1;
                                                $this->db->reconnect();
                                                $result = $this->db->query("call get_total_nilai_list('$id')");
                                                foreach ($result->result_array() as $row) {
                                                ?>
                                                    <tr>
                                                        <td><?= $no ?></td>
                                                        <td><?= $row['nama'] ?></td>
                                                        <td><?= $row['asal_sekolah'] ?></td>
                                                        <td><?= $row['no_hp'] ?></td>
                                                        <td>
                                                            <a href="<?= base_url('LiveScore/detailnilai') ?>?no_p=<?= $row['no_peserta'] ?>">
																<?= $row['total_nilai'] ?>
															</a>
                                                        </td>
                                                    </tr>
                                                <?php
                                                    $no++;
                                                }; ?>
                                            </tbody>
                                        </table>
                                    <?php
                                    }; ?>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>

    </div>


    <script src="<?= base_url('assets/'); ?>vendor/jquery/jquery.min.js"></script>
	<script src="<?= base_url('assets/'); ?>vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

	<!-- Core plugin JavaScript-->
	<script src="<?= base_url('assets/'); ?>vendor/jquery-easing/jquery.easing.min.js"></script>

	<!-- Custom scripts for all pages-->
	<script src="<?= base_url('assets/'); ?>js/sb-admin-2.min.js"></script>
	<script src="<?= base_url('assets/'); ?>ckeditor/ckeditor.js"></script>

	<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
	<script src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js"></script>
	<script src="https://cdn.datatables.net/1.10.25/css/jquery.dataTables.min.css"></script>
	<script src="https://cdn.datatables.net/1.10.25/js/dataTables.bootstrap4.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.7.1/css/buttons.dataTables.min.css"></script>

	<script src="https://cdn.datatables.net/buttons/1.7.1/js/dataTables.buttons.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.7.1/js/buttons.html5.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.7.1/js/buttons.print.min.js"></script>
    <script type="">
$(document).ready(function() {
    $('#score').DataTable( {
        dom: 'Bfrtip',
        buttons: [
            'copy', 'csv', 'excel', 'pdf', 'print'
        ]
    } );
} );
</script>

</body>

</html>
