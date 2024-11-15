<div>
    <label class="form-label">
        {{ $slot }}
    </label>
    <div class="input-group mb-3">
        <input type="text" class="form-control" value="{{ $attributes['value'] }}" aria-label="Recipient's username" aria-describedby="button-addon2" {{ $attributes }}>
        <button class="btn text-info" type="button" id="button-addon2">
            Ubah
            <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 15 15" fill="none">
                <path fill-rule="evenodd" clip-rule="evenodd" d="M13.7789 0.209707C13.4996 -0.0699022 13.0467 -0.0699022 12.7674 0.209707L12.1434 0.834297C11.3457 0.452891 10.3615 0.592841 9.70079 1.25415L2.11402 8.8483L6.1603 12.8985L13.7471 5.30436C14.4077 4.64305 14.5475 3.65782 14.1665 2.8594L14.7905 2.23481C15.0698 1.9552 15.0698 1.50187 14.7905 1.22226L13.7789 0.209707ZM10.7261 6.30318L6.1603 10.8734L4.13716 8.8483L8.70295 4.27807L10.7261 6.30318ZM12.0267 5.00132L12.7355 4.29181C13.0148 4.0122 13.0148 3.55886 12.7355 3.27926L11.7239 2.2667C11.4446 1.98709 10.9917 1.98709 10.7124 2.2667L10.0035 2.97622L12.0267 5.00132Z" fill="#39B5FF"/>
                <path d="M0 15L1.51763 9.43068L5.56363 13.4812L0 15Z" fill="#39B5FF"/>
            </svg>
        </button>
    </div>
</div>
